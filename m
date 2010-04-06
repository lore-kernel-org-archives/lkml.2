Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab0DFQpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 12:45:31 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:35649 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab0DFQpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 12:45:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=U7nVnMTOAsdumcCAAjl/xCKL4UpNdqWYM0S5hY5eudwhUsDzFP1AAk0E56cNMEX/xE
         QjI7pCKVJI4jJ1cUJmSVdkb/yRhXnI7LptVEeCF/BnU1GSrwM/WDl9dSth9Hvm8uCrGV
         fcslQaiosqce9svCzt8lntDkIzqVSWPR4JIQk=
Date: Tue, 6 Apr 2010 19:45:12 +0300
From: Dan Carpenter <error27@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Shaun Ruffell <sruffell@digium.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch v2] dma-debug: cleanup for loop
Message-ID: <20100406164512.GF21229@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Joerg Roedel <joro@8bytes.org>, Joerg Roedel <joerg.roedel@amd.com>,
	Ingo Molnar <mingo@elte.hu>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	Shaun Ruffell <sruffell@digium.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <20100402112843.GI5265@bicker> <20100403204717.GS24846@8bytes.org> <20100405125329.GA16197@bicker> <20100405140215.GA29758@8bytes.org> <20100405140909.GB29758@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100405140909.GB29758@8bytes.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Earlier in this function we set the last byte of "buf" to NULL so we 
always hit the break statement and "i" is never equal to NAME_MAX_LEN.  
This patch doesn't change how the driver works but it silences a Smatch 
warning and it makes it clearer that we don't write past the end of the 
array.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index ba8b670..01e6427 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -570,7 +570,7 @@ static ssize_t filter_write(struct file *file, const char __user *userbuf,
 	 * Now parse out the first token and use it as the name for the
 	 * driver to filter for.
 	 */
-	for (i = 0; i < NAME_MAX_LEN; ++i) {
+	for (i = 0; i < NAME_MAX_LEN - 1; ++i) {
 		current_driver_name[i] = buf[i];
 		if (isspace(buf[i]) || buf[i] == ' ' || buf[i] == 0)
 			break;
