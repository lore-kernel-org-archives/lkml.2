Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab0KVNdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 08:33:55 -0500
Received: from igw2.watson.ibm.com ([129.34.20.6]:59340 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab0KVNdy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 08:33:54 -0500
Subject: Re: [PATCH v1.2 0/5] IMA: making i_readcount a first class inode
 citizen (reposting)
From: David Safford <safford@watson.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jmorris@namei.org, akpm@linux-foundation.org, eparis@redhat.com,
        viro@zeniv.linux.org.uk, Dave Chinner <david@fromorbit.com>
In-Reply-To: <1290375229.2412.95.camel@localhost.localdomain>
References: <1290121382-4039-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <AANLkTin9sYf99fQ_w7Bp4N6Gsm3PR0akpCU=4YEkOaez@mail.gmail.com>
	 <20101119175053.GC29148@fieldses.org>
	 <1290345498.2412.38.camel@localhost.localdomain>
	 <AANLkTikjz3j4j-zLSzagF=wnVE1ROZBGsjtuhGEvB9=n@mail.gmail.com>
	 <1290375229.2412.95.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 22 Nov 2010 08:33:02 -0500
Message-ID: <1290432782.2718.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-21 at 16:33 -0500, Mimi Zohar wrote:
> On Sun, 2010-11-21 at 09:56 -0800, Linus Torvalds wrote:
> > On Sun, Nov 21, 2010 at 5:18 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > >
> > > IMA (and the proposed EVM/IMA-appraisal patches) detects file change
> > > based on i_version. When the file is closed, if the file has changed,
> > > IMA marks the file as needing to be re-measured. Of course this requires
> > > the filesystem to be mounted with iversion. Don't know if this helps.
> > 
> > If you only do this at close time, I see a _major_ security hole.
> > 
> > The attacker can just write to the file, and keep it open. Ta-daa,
> > everybody who reads it sees the new contents, but your IMA logic is
> > oblivious and thinks it doesn't need to be re-measured.
> > 
> >                             Linus
> 
> Not exactly.  While the file remains open for write, it doesn't make any
> sense to re-measure the file, as there is nothing preventing the file
> from continuing to change.  Any measurement would thus be meaningless.
> Only after the file closes, does it make sense to re-measure.  I did not
> mean to imply there isn't any indication of the problem in the
> measurement list, there obviously is.
> 
> Mimi
> 
To elaborate a bit on Mimi's response - in the case of a malicious
program keeping a file open for write to avoid measurement:
1. as she points out, the reason for i_writecount and i_readcount
   is to detect this "open_writer" problem and log it in both the 
   measurement list and in the audit log.
2. the attacker program itself must have been measured before it
   was executed. 

dave
