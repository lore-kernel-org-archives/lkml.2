Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab1GRSrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 14:47:01 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:55742 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751379Ab1GRSq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 14:46:59 -0400
X-Greylist: delayed 528 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jul 2011 14:46:59 EDT
Date: Mon, 18 Jul 2011 08:45:03 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: David Safford <safford@watson.ibm.com>
Cc: Kyle Moffett <kyle@moffetthome.net>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>
Subject: Re: [PATCH v7 00/16] EVM
Message-ID: <20110718134503.GC8127@mail.hallyn.com>
References: <1309377038-4550-1-git-send-email-zohar@linux.vnet.ibm.com>
 <BANLkTinSsqBqX7=jzwbw_=RfXeQz29h_+A@mail.gmail.com>
 <1309390941.3205.22.camel@localhost.localdomain>
 <BANLkTineYVKw9MMQUqRGJ6Q_yEfgmsgJxg@mail.gmail.com>
 <1310656045.3845.243.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310656045.3845.243.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Safford (safford@watson.ibm.com):
> On Wed, 2011-06-29 at 21:57 -0400, Kyle Moffett wrote:
> > There have been numerous cases in the past where a corrupt or invalid
> > filesystem causes kernel panics or even exploitable overflows or memory
> > corruption; see the history of the "fsfuzzer" tool for more information.
> 
> Seems to me code bugs in the kernel should be fixed, given the universal 
> practice of automounting of removable media, and loopback mounting 
> images, regardless of EVM.

Hi David,

yeah, this would also be nice for making people feel cozier about
supporting unprivileged fs mounts in general.  I wonder if a real
project around the idea of strengthening the robustness of the fs
code, starting with the superblock parsing for a few of the most
comment filesystems, could take off.  A combination of

  . code auditing and test (i.e. fsfuzzer)
  . moving parts of the code to unprivileged userspace
  . marking audited filesystems as unprivileged-mountable, in the
    way Miklos' patchset a few years ago did
  . so that those who want to can refuse auto-mount of any not
    audited filesystems.

-serge
