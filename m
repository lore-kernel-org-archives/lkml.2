Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635Ab2EVAf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 20:35:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51343 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800Ab2EVAfZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 20:35:25 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1205211426040.1725-100000@iolanthe.rowland.org>
References: <CACVXFVPeicEStTqtdO3Jt32JuhP3+_kof7vqgErK_iSDWdt92w@mail.gmail.com>
	<Pine.LNX.4.44L0.1205211426040.1725-100000@iolanthe.rowland.org>
Date: Tue, 22 May 2012 08:35:21 +0800
Message-ID: <CACVXFVMCaYPWMiWeKa7tz=Xmi4PLez-3=1rnVPODYvSXBG4Y2Q@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_Race_condition_between_driver=5Fprobe=5Fdevice_and_d?=
	=?UTF-8?Q?evice=5Fshutdown=E2=80=8F?=
From: Ming Lei <ming.lei@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Linux PM List <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 2:29 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 21 May 2012, Ming Lei wrote:
>> Another candidate fix is to register a reboot notifier in driver core to prevent
>> driver from being bound or unbound from start of reboot/shutdown, but looks
>> not easy as the way of holding device locks.
>
> I'd guess it was done this way so that the shutdown task wouldn't have
> to wait for a buggy driver that didn't want to release the device lock
> (or that crashed while holding the lock).

Maybe, so I understand you agree on adding the device lock as did
in the patch, don't I?

Also we can add below line before acquiring device lock to help
toubleshoot buggy driver.

               dev_dbg(dev, "acquiring device lock for shutdown\n");

>
> It's not clear that the reboot notifier approach would work.  What
> about probes that had already started when notifier was called?

Looks holding device lock is still needed in the notifier callback for
handling the case if reboot notifier approach is taken.

IMO, the way of holding device lock is better than reboot notifier approach.

Thanks,
--
Ming Lei
