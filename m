Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab2F1Phe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 11:37:34 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:45644 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab2F1Phd convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:10:1>);
	Thu, 28 Jun 2012 11:37:33 -0400
Message-Id: <4FEC9686020000780008C9BB@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 28 Jun 2012 16:38:14 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: <cyclonusj@gmail.com>, <rostedt@goodmis.org>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        <marmarek@invisiblethingslab.com>, <x86@kernel.org>,
        <tglx@linutronix.de>, <xen-devel@lists.xensource.com>,
        <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        "Jason Garrett-Glaser" <jason@x264.com>
Subject: Re: [Xen-devel] [PATCH] x86 fixes for 3.3 impacting distros
 (v1).
References: <1328888091-9692-1-git-send-email-konrad.wilk@oracle.com>
 <CABS55+BFrDUV-WR=nx+d6+ZJngpuZnh41DZ3NYU4adFqaxqaNA@mail.gmail.com>
 <20120510153457.GB6389@phenom.dumpdata.com>
 <20120627231755.GA1021@gmail.com>
 <20120628142836.GE8956@phenom.dumpdata.com> <4FEC6D44.8080807@zytor.com>
In-Reply-To: <4FEC6D44.8080807@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.06.12 at 16:42, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 06/28/2012 07:28 AM, Konrad Rzeszutek Wilk wrote:
>> I also chatted with the core Xen hypervisor folks about adding in the 
> context switch code
>> to alter the PAT layout - but they were not keen a about it - and I am not 
> sure how much
>> CPU cycles one loses by doing a wrmsr to the PAT register on every guest 
> context switch
>> (worst case when on has a pvops kernel and a old-style one - where the WC bit 
> would differ)?
>> 
> 
> And you're comparing that to a bunch of new pvops calls?  The discussion
> shouldn't even have started until you had ruled out this solution and
> had data to show it.

That's definitely not an option: Xen itself may be (and is, under
certain circumstances at least) using WC page table entries, so
we can't allow on-the-fly changes to the meaning of the various
indexes.

Jan

