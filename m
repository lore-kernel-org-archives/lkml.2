Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab0JWJMd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 05:12:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62485 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab0JWJMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 05:12:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH update] firewire: nosy: char device is not seekable
Date: Sat, 23 Oct 2010 10:57:17 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <tkrat.42de7ec9907e63aa@s5r6.in-berlin.de> <201010131554.43089.arnd@arndb.de> <tkrat.f853df65a5128ca0@s5r6.in-berlin.de>
In-Reply-To: <tkrat.f853df65a5128ca0@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010231057.18135.arnd@arndb.de>
X-Provags-ID: V02:K0:JlvPon4fNaO9NGoCjPvma0Doah2IuZpsOO1FkAibRvS
 JI/AmEi2nzz4Z+UYNg4pPwTgRLBOmpRdy7Ehr395cn8kskyjU+
 EV+ATkjrgeexzFRRhXsAxzhRiZsZ6lDJ6s5Dtq+zwqfv02QkAT
 KUSousmDMHkOA7R2kHQJVYcM4Xdf3mb/M5dwNxxMSbxGT1Ax1Y
 0t4GGXtVr3bZU5EDM65eQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 October 2010, Stefan Richter wrote:
> Remove unnecessary .llseek handler that came in via an automated mass conversion.
> .llseek = NULL means no_llseek since commit 776c163b1b93.
> 
> The only client that uses this interface is nosy-dump in linux/tools/firewire
> and it knows not to seek in this char dev.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
> I left out the addition of return nonseekable_open(...) in nosy_open in
> this update.  This works for nosy, but is it also formally correct?
> 

Most likely you also want the nonseekeable_open, which would prevent
both llseek and pread/pwrite, whereas leaving out llseek currently
only prevents llseek.

	Arnd

