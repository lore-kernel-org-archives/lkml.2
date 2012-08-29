Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab2H2Rhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 13:37:45 -0400
Received: from nm30-vm2.bullet.mail.ne1.yahoo.com ([98.138.91.130]:41140 "HELO
	nm30-vm2.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754276Ab2H2Rhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 13:37:42 -0400
X-Greylist: delayed 358 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Aug 2012 13:37:42 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 67316.16317.bm@omp1056.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=LM1924+BAZxuixY4SKkhaLRL9J6ql9cm5+QwhNikRrg8CVO4QZupnHPDHXLWZPl3G3OgljmAcUOZPZMzAHwZoXjxuy28cRlxrbTvw/HkDT8OvN9VqsGZzyh1zLXbuus5Z3rJMtCZIBmDPEPdn/q75ohjwF5o30AgoXT/CBoHtqY=;
X-YMail-OSG: u5GvI2kVM1nhrkFT_MyrEqhKVMml7ZJg7FiuAnf9LqXYxip
 ujlCGHnlTaNcfGsSMG7_ceo6m9fVOVLk7E1EPE_8GI_lWCyzaafk47guC4bv
 Xxw5R0wQdJ6GndvZtb77o4Wwg8se01HECPf2jXAk4D4R93k0t5aIXSSeP_w_
 oF1fo6_R_7TPKKldDo4oSPz_rUCciaFcvv1kas._EN8fY_s7fbdw3ubvDJNX
 rHFBScNcPQOCx0GqFa2Ur3mdHfV3Cj7_Syc_xvkXeyKI2fBDsP.N9dtkfTD8
 _UKIqXFYijB8w2p5xXnKFl4x9smDpbqozQQ91Ttv3549ibCDZV4mUygWwsXO
 hlRy_usXQr5cKTqoi4vcYCRNp2LzFAw4G.0SEy3l14FW5Mpw5Clq49bsgSKU
 9jwBfqbhjKCCCJwkn.5maB5Q1y7gD2BVKbdqxMgiv
X-Mailer: YahooMailWebService/0.8.121.416
References: <1345901771.8871.YahooMailNeo@web124706.mail.ne1.yahoo.com> <20120826130152.GA20021@liondog.tnic> <1346086872.65665.YahooMailNeo@web124704.mail.ne1.yahoo.com> <20120827215952.GA18719@liondog.tnic>
Message-ID: <1346261503.91611.YahooMailNeo@web124703.mail.ne1.yahoo.com>
Date: Wed, 29 Aug 2012 10:31:43 -0700 (PDT)
From: Adko Branil <adkobranil@yahoo.com>
Reply-To: Adko Branil <adkobranil@yahoo.com>
Subject: Re: HDD problem, software bug, bios bug, or hardware ?
To: Borislav Petkov <bp@alien8.de>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20120827215952.GA18719@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And one more thing i forgot - during kernel compilation i noticed this:

WARNING: modpost: Found 1 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'



And when i compiled with "make CONFIG_DEBUG_SECTION_MISMATCH=y", somewhere at the end was:


WARNING: drivers/scsi/fcoe/libfcoe.o(.init.text+0x1f): Section mismatch in reference from the function libfcoe_init() to the function .exit.text:fcoe_transport_exit()
The function __init libfcoe_init() references
a function __exit fcoe_transport_exit().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __exit annotation of
fcoe_transport_exit() so it may be used outside an exit section.



It should not be related with the crash during "make modules_install", as the default slackware kernel 3.2.27 also crashes during it, but it may be important for any other things, i don't know.


Thanks !
Adko.

