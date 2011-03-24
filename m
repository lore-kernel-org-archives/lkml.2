Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933807Ab1CXSwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:52:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45587 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125Ab1CXSwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:52:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=GwG3KumoHv/IjV9kv71EuGMv1KMSLLpPGq2jasHpH9TddRt/rYyuptGQxwJr78GsiB
         +YSKvHuCgO8+mvvV3hxcxgzarMFxFtF0OHWDytBWkg5tECmuDQuZOdkVyRejNCkJAZ9L
         aFHOH60HKcKILpaarr2VeWSvhQGqKW8JRcVtA=
Date: Thu, 24 Mar 2011 20:52:09 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kstrtox: simpler code in _kstrtoull()
Message-ID: <20110324185209.GB12383@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 lib/kstrtox.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/lib/kstrtox.c
+++ b/lib/kstrtox.c
@@ -49,12 +49,9 @@ static int _kstrtoull(const char *s, unsigned int base, unsigned long long *res)
 			val = *s - '0';
 		else if ('a' <= _tolower(*s) && _tolower(*s) <= 'f')
 			val = _tolower(*s) - 'a' + 10;
-		else if (*s == '\n') {
-			if (*(s + 1) == '\0')
-				break;
-			else
-				return -EINVAL;
-		} else
+		else if (*s == '\n' && *(s + 1) == '\0')
+			break;
+		else
 			return -EINVAL;
 
 		if (val >= base)
