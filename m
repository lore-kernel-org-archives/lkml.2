Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab1CRHMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 03:12:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54451 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab1CRHMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 03:12:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=OyKd7URTb/hv8sXwkdcAIdK3ILlEKSKTfVCBG/+y8ubDe/FzRq3BfKn6cF4dB/An6a
         Yz5nV49Fj6Pmu4qEE7KDGvy7/E45yhXZt1Ain9jObu4OOL2pkscfd7LvBA7yQ5Scq7em
         vV1FbzijlqVD0Hl7HFIZAbEtgojG8MMugG3E0=
Date: Fri, 18 Mar 2011 10:12:14 +0300
From: Dan Carpenter <error27@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mike Waychison <mikew@google.com>, Chris Wright <chrisw@sous-sol.org>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch 1/2] efivars: memory leak on error in
 create_efivars_bin_attributes()
Message-ID: <20110318071214.GV2008@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Mike Waychison <mikew@google.com>,
	Chris Wright <chrisw@sous-sol.org>, Tejun Heo <tj@kernel.org>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cut and paste bug.  We intended to free ->del_var and
->new_var but we only free ->new_var.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index ff0c373..ff2fe40 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -677,8 +677,8 @@ create_efivars_bin_attributes(struct efivars *efivars)
 
 	return 0;
 out_free:
-	kfree(efivars->new_var);
-	efivars->new_var = NULL;
+	kfree(efivars->del_var);
+	efivars->del_var = NULL;
 	kfree(efivars->new_var);
 	efivars->new_var = NULL;
 	return error;
