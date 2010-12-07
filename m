Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab0LGQMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 11:12:38 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40032 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab0LGQMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 11:12:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BvJ3f9zWatjM2lC22fJqFROSePyqHA1VHLUSKUCh5OwDI/gXtlzTuF/kqlDtSaF+Mr
         bQMuLhUU+12OmXpiJsMZabnZCvt8Md6vBA0N2LjF67TjHh9bdUW2qO/sa0vZwTQIj1Zo
         bwssDxGl5Mm6eh+QWbUpu55m/eCPAPjisc1Qg=
Subject: Re: [PATCH 1/3] [SCSI] dpt_i2o: fix compiler warning on dptids
From: Namhyung Kim <namhyung@gmail.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adaptec OEM Raid Solutions <aacraid@adaptec.com>
In-Reply-To: <1291737421.17668.5.camel@mulgrave.site>
References: <1291735896-14541-1-git-send-email-namhyung@gmail.com>
	 <1291737421.17668.5.camel@mulgrave.site>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Dec 2010 01:12:28 +0900
Message-ID: <1291738348.1638.9.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-12-07 (화), 09:57 -0600, James Bottomley:
> Um so this is definitely used in the MODULE_DEVICE_TABLE just below.
> 
> I deduce you have some type of config which causes that to be a nop
> (say !CONFIG_MODULE)?  In which case, surely the correct fix is in
> module.h?
> 

Hi,

MODULE_DEVICE_TABLE expands to nop when !MODULE (not !CONFIG_MODULE) so
allyesconfig build always emits the warnings. Possible patch for this
would be wraping it up in #ifdefs but when I sent a same patch to Greg
KH he didn't want to add more #ifdefs in .c files.

-- 
Regards,
Namhyung Kim


