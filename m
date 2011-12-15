Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863Ab1LOPeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 10:34:12 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64736 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab1LOPeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 10:34:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: myungjoo.ham@samsung.com
Subject: Re: [PATCH 2/2] misc: add driver support for MAX8997 MUIC
Date: Thu, 15 Dec 2011 15:34:01 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        =?euc-kr?q?=B1=E8=B5=BF=B1=D9?= <dg77.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        =?euc-kr?q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>
References: <33434703.581501323909131767.JavaMail.weblogic@epml15>
In-Reply-To: <33434703.581501323909131767.JavaMail.weblogic@epml15>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="euc-kr"
Content-Transfer-Encoding: 7bit
Message-Id: <201112151534.01995.arnd@arndb.de>
X-Provags-ID: V02:K0:Wo+rClDX0soB2REYMov0urxFlCET5cJFKuhR3f9KRjP
 ZGytsUUKZuGUx1SSAPcvgNrqD0n6gKwXWrqNkP27AuC0bfZm6i
 sEs5j5mboANYiXvH3+DxXsSLJxkgt7/i26Rp1L2mbn2QsFYOud
 lx22uIZw0s9uMbKkensAnygKCYpKeLq5YzjhRXllAO1EHaDqEr
 6dN2BSNcogxsu5/MfH5Gyej+sVHo/J6+G1SqkBD+Z+DUwp6ip3
 Zbn5kKCbqXAz4nDstHYwivT62k6sAdAftAnPwo2h989VYJhG1x
 SEfdfEFQujbRZFgJZ8LGfWJ8Pzphm5vP3eL+huu0txIOUVkZKr
 4AKD5VcH2FIfEod+a2zY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 December 2011, MyungJoo Ham wrote:
> Arnd Bergmann wrote:
> > On Monday 12 December 2011, Samuel Ortiz wrote:
> > The part that is not clear to me is how this new driver fits in
> > with the first fsa9480 driver and the currently discussed extcon
> > subsystem, apparently all written by the same team at Samsung.
> > Is this misc driver still useful when the extcon framework gets
> > merged?
> 
> When extcom gets merged, this driver should be updated. It looks like allowing
> the interrupt handler to update extcon state would be enough. Bascially, this
> is all this driver is required for extcon to work. (and the prvious author of
> extcon--"extended" switch class at that time--was the author of this patch.)
> 
> Anyway, this patch has just told me that I'll need to add more sysfs entries
> for extcon to show the list of cable names and/or to show the status for each
> of them, soon or later.

I think it would be better not to merge this driver until the user interface
in the extcon framework has been finalized. I don't mind the driver, but I
want to prevent user interfaces from appearing in the kernel that we
intend to change anyway.

How about dropping the driver from the mfd tree, and adding it into the
extcon series for the next posting?

	Arnd
