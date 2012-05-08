Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab2EHX4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 19:56:07 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:18229 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab2EHX4F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 19:56:05 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-160.messagelabs.com!1336521362!5832198!3
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Tue, 8 May 2012 18:55:59 -0500
Subject: RE: [PATCH] staging: comedi: remove __user annotation inside of
 struct's
Thread-Topic: [PATCH] staging: comedi: remove __user annotation inside of
 struct's
Thread-Index: Ac0tdC1JNTcA7Ri6ToikClTJYi6DsQAAQ1Wg
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698A1774D@AUSP01VMBX24.collaborationhost.net>
References: <201205081641.00358.hartleys@visionengravers.com>
In-Reply-To: <201205081641.00358.hartleys@visionengravers.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 08, 2012 4:41 PM, H Hartley Sweeten wrote:
>
> The structs' comedi_insn, coomedi_insnlist, comedi_cmd,
> comedi_chaninfo, and comedi_rangeinfo are all passed to
> the kernel from user space using ioctl commands. They
> are then copied to kernel space using copy_from_user()
> before the data is passed to the drivers.
>
> The __user annotation should not be used with variables
> inside the struct. This produces a lot of sparse warnings
> like:
>
> warning: dereference of noderef expression 
>
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: Mori Hess <fmhess@users.sourceforge.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>
> Note: This patch exposes some new warnings about different
> address space. These will be addressed.

Please ignore this patch.

It appears the annotations in the struct definitions are correct.

The initial copy_from_user will only copy the data  from the
struct __user *arg to the kernel's struct * it doesn't copy the
data that the struct variable points to, just the pointer. To get
that data another copy_from_user needs to be done.

The sparse warnings above will need to be addressed a
different way.

Sorry for the noise.

Regards,
Hartley
