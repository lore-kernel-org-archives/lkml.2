Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab2GZMWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 08:22:55 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:34340 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab2GZMWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 08:22:52 -0400
Date: Thu, 26 Jul 2012 14:22:48 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [RFC PATCH] KVM: Only print vcpu_unimpl when DEBUG is set
Message-ID: <20120726122248.GA252@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every time I start qemu-kvm on my system the following line is added to
the syslog:

 vcpu0 unhandled rdmsr: 0xc0010001

AFAICS all calls to vcpu_unimpl only contain debugging info with little
or no value for the end user.

Wouldn't something like the following patch make sense?

Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b70b48b..6bd816f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -321,7 +321,7 @@ struct kvm {
 #define kvm_debug(fmt, ...) \
 	pr_debug("kvm [%i]: " fmt, task_pid_nr(current), ## __VA_ARGS__)
 #define kvm_pr_unimpl(fmt, ...) \
-	pr_err_ratelimited("kvm [%i]: " fmt, \
+	pr_debug_ratelimited("kvm [%i]: " fmt, \
 			   task_tgid_nr(current), ## __VA_ARGS__)
 
 /* The guest did something we don't support. */

-- 
Markus
