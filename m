Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934001Ab0KPIhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 03:37:09 -0500
Received: from static.206.114.40.188.clients.your-server.de ([188.40.114.206]:47879
	"EHLO mail.tastatur-junkie.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756716Ab0KPIhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 03:37:07 -0500
X-Spam-Flag: NO
X-Spam-Score: 2.287
From: Markus Schulz <msc@antzsystem.de>
Organization: AntzSystem GmbH
To: "Ed Lin - PTU" <ed.lin@promise.com>
Subject: Re: data corruption with stex (Promise HW-Raid) driver and device-mapper
Date: Tue, 16 Nov 2010 09:37:14 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc6-686-bigmem; KDE/4.4.5; i686; ; )
Cc: "Dan Carpenter" <error27@gmail.com>, linux-kernel@vger.kernel.org
References: <85ABFDC4641C4847BA6088F2982EFD8F049D4273@nonamew.ptu.promise.com>
In-Reply-To: <85ABFDC4641C4847BA6088F2982EFD8F049D4273@nonamew.ptu.promise.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Message-Id: <201011160937.15432@Mail-Followup-To>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 16. November 2010 schrieb Ed Lin - PTU:
> Hello,
> 
> We found similar problem during test.
> 
> The stex driver sets sg_tablesize as 32 (for st_yel it's 38) in the
> probe entry. It seems that this value was overridden by the system
> if using dm/lvm, for unknown reason. The driver received requests
> with more sg items than registered. Sg item number could be as high
> as 64. This is completely unexpected. The firmware could not handle
> such requests, and error occurred.
> 
> The problem can be easily reproduced using a minimum test that only
> requires copying files from system usr directory to stex dm volume
> (ext2). The stex dm volume was created using the command
> "echo 0 51200000 linear /dev/sdb1 0 | dmsetup create sdb".
> The problem should exist on every kernel since 2.6.32. The problem
> did not occur on 2.6.31 using similar minimum test.

ok, but this would not explain why all my tests with ext3 are working? 
Until now  i've found no way to generate errors on stex-disk + dm + 
ext3.
I will try your simple test now.

regards,
msc
