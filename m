Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab0COVuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 17:50:44 -0400
Received: from tundra.namei.org ([65.99.196.166]:45853 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936912Ab0COVuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 17:50:40 -0400
Date: Tue, 16 Mar 2010 08:50:32 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: linux-next: build warning after merge of the security-testing
 tree
In-Reply-To: <20100310153116.291d4e6f.sfr@canb.auug.org.au>
Message-ID: <alpine.LRH.2.00.1003160850080.13724@tundra.namei.org>
References: <20100310153116.291d4e6f.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Mar 2010, Stephen Rothwell wrote:

> Hi James,
> 
> After merging the security-testing tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
> 
> scripts/selinux/genheaders/genheaders.c: In function 'main':
> scripts/selinux/genheaders/genheaders.c:84: warning: initialization discards qualifiers from pointer target type
> 
> Introduced by commit 634a539e16bd7a1ba31c3f832baa725565cc9f96 ("selinux:
> const strings in tables").

Thanks, fix applied per below.

commit 310de047eef6685274045db1e6b39c9f313df428
Author: James Morris <jmorris@namei.org>
Date:   Tue Mar 16 08:47:36 2010 +1100

    selinux: fix warning in genheaders
    
    Fix const warning in the genheaders script as a result of
    changes to the headers, as noted here:
    
    http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-03/msg03977.html
    
    Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Signed-off-by: James Morris <jmorris@namei.org>

diff --git a/scripts/selinux/genheaders/genheaders.c b/scripts/selinux/genheaders/genheaders.c
index 2462696..58a12c2 100644
--- a/scripts/selinux/genheaders/genheaders.c
+++ b/scripts/selinux/genheaders/genheaders.c
@@ -81,7 +81,7 @@ int main(int argc, char *argv[])
 	fprintf(fout, "\n");
 
 	for (i = 1; i < isids_len; i++) {
-		char *s = initial_sid_to_string[i];
+		const char *s = initial_sid_to_string[i];
 		fprintf(fout, "#define SECINITSID_%s", s);
 		for (j = 0; j < max(1, 40 - strlen(s)); j++)
 			fprintf(fout, " ");

