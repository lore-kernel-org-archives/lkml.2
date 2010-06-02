Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab0FBOSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 10:18:52 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:52768 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab0FBOSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 10:18:50 -0400
Subject: Re: [PATCH 00/14] EVM
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Cc: ext Shaz <shazalive@gmail.com>, James Morris <jmorris@namei.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       securityengineeringresearchgroup 
	<securityengineeringresearchgroup@googlegroups.com>
In-Reply-To: <4C062092.2030608@nokia.com>
References: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <alpine.LRH.2.00.1005311017530.24571@tundra.namei.org>
	 <AANLkTil8LHjRT_PMosymmtBb1pxIzkBaWC0ef35DCBUU@mail.gmail.com>
	 <AANLkTil7WvVZ-3zpA0E--fUcHTqul3pnXnPm1xXn_vlH@mail.gmail.com>
	 <1275420536.28134.37.camel@localhost.localdomain>
	 <4C060224.4090601@nokia.com>
	 <AANLkTikuXjWTEfYG2JLNW6znGGKNxzobw3ijCpG7u1xz@mail.gmail.com>
	 <4C062092.2030608@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Jun 2010 10:02:20 -0400
Message-ID: <1275487340.3068.74.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-02 at 12:12 +0300, Dmitry Kasatkin wrote:
> On 02/06/10 10:50, ext Shaz wrote:
> > On Wed, Jun 2, 2010 at 12:03 PM, Dmitry Kasatkin
> > <dmitry.kasatkin@nokia.com> wrote:
> >   
> >>
> >> On 01/06/10 22:28, ext Mimi Zohar wrote:
> >>     
> >>> On Mon, 2010-05-31 at 15:08 +0500, Shaz wrote:
> >>>
> >>>       
> >>>>> EVM is based on EA while Aegis does not use EA as far as I can
> >>>>> understand from the documentation available. Can we make EVM
> >>>>> independent of EA? Even the MAC mechanism is very different then
> >>>>> existing LSM based mechanisms.
> >>>>>
> >>>>>           
> >>>> Have a look at the following:
> >>>>
> >>>> http://research.nokia.com/files/NRCTR2008010.pdf
> >>>> http://research.nokia.com/files/NRCTR2008007.pdf
> >>>> http://lwn.net/Articles/372937/
> >>>>
> >>>>         
> >>> SELinux, Smack, Capabilities, and IMA all use extended attributes. The
> >>> purpose of EVM is to detect offline tampering of these security extended
> >>> attributes.
> >>>       
> > MeeGo/Maemo security framework does not use LSM because Maemo/MeeGo
> > security framework only focuses at process level MAC and for that they
> > use Dazuko as Nokia research report mentions.
> >
> > By the way MeeGo 1.0 has no security at the moment so one cannot be
> > sure if they are going according to their research or what. They are
> > also not opening the internals of their security framework. Not sure
> > why if the whole thing is open and Linux Foundation is backing it up.
> >
> >   
> Maemo/MeeGo does not do exactly what is written in that research report.
> It has been done in parallel to our work.
> And we do use LSM.
> 
> We go approval from company layers to open source the work.
> We will see what to do next.
> 
> >>> The IMA integrity appraisal extension extends IMA with local measurement
> >>> appraisal. The extension stores and maintains the file integrity
> >>> measurement as an extended attribute 'security.ima', which EVM can be
> >>> configured to protect.  Instead of storing the hash measurement as an
> >>> extended attribute, the file hashes could be loaded in kernel memory, as
> >>> long as the appraise policy is appropriately constrained.
> >>>
> >>>
> >>>       
> >> Hi,
> >>
> >> Maemo integrity protection solution was based on old DigSig project
> >> which was used to verify
> >> integrity of executables. Signed integrity measurement was embedded to
> >> the ELF header.
> >> When we started to develop it EVM was not available.
> >>
> >> And we decided to use a file to keep hashes and other info.
> >>
> >> Our goals were
> >> 1. Protect also certain data files.
> >> digsig worked only with ELF files.
> >>
> >> 2. Be mobile friendly
> >> It seems faster to verify signature of one file with hashes instead of
> >> checking signature of every EA.
> >>     
> > Here Mimi can explain better because I am of the same opinion as yours
> > if you mean that all signatures lie in one file and you check it from
> > there. Anyways some sort of policy can reduce checking every EA ... I
> > guess.

Yes, verifying one file containing the hashes would be faster than
verifying individual hashes stored as extended attributes (xattrs), but
this does not take into account that files on a running system are being
modified or added. On a small form factor, the number of files is
limited, but would this scale well? In addition, what protects that one
file containing all the hashes from being modified?  So, if you limit
the types of files to those that don't change, and the number of file
hashes, then using a single file would be faster.
      
> >> 3. Persistant to offline attacks
> >> EA can be delete. If not all files has EA then it is not possible to
> >> detect removal
> >>     
> > Availability of EA on all file systems needs some effort but it's not
> > a big deal. I have even seen patches for yaffs2.
> >
> >   
> The issue was removal.

Yes, exactly.  The original EVM required that all files be labeled.
Anything unlabeled was untrusted.  The current implementation is based
upon policy with the default policy being to only appraise all files
owned by root.

> >> 4. Do not use EA.
> >> IIRC it was some problems with EA on our system and we could not use them..
> >>     
> > This is a bad excuse :)
> >
> >   
> Yes. not so convincing...
> >> EVM looks very interesting and I would like also to review the code and
> >> understand the architecture.
> >> We consider possibility to use EVM if it is going to be in the kernel.

Am looking forward to your questions/comments.
    
> > Please do have a look because we need these features too but in a
> > light weight manner. We are trying to make available similar
> > functionality for OpenMoko based software stacks.
  
Glad to hear it.

Mimi

