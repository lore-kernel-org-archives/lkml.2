Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab1FOKBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 06:01:46 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:15083 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab1FOKBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 06:01:45 -0400
Date: Wed, 15 Jun 2011 11:53:13 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org
Subject: [PATCH/Trivial] docproc: cleanup brace placement
Message-ID: <alpine.LNX.2.00.1106151148070.2452@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The placement of the opening brace "{" after 'if' statements in 
scripts/docproc.c is inconsistent. Most are placed on the same line as the 
'if' statement itself as per CodingStyle, but a few are not.
This patch cleans up the inconsistency. We save a few source lines and the 
file then uses the same style throughout, which is nice.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 docproc.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/scripts/docproc.c b/scripts/docproc.c
index 98dec87..4cfdc17 100644
--- a/scripts/docproc.c
+++ b/scripts/docproc.c
@@ -205,8 +205,7 @@ static void find_export_symbols(char * filename)
 				PATH_MAX - strlen(real_filename));
 		sym = add_new_file(filename);
 		fp = fopen(real_filename, "r");
-		if (fp == NULL)
-		{
+		if (fp == NULL)	{
 			fprintf(stderr, "docproc: ");
 			perror(real_filename);
 			exit(1);
@@ -487,8 +486,7 @@ static void parse_file(FILE *infile)
 				default:
 					defaultline(line);
 			}
-		}
-		else {
+		} else {
 			defaultline(line);
 		}
 	}
@@ -519,8 +517,7 @@ int main(int argc, char *argv[])
                 exit(2);
         }
 
-	if (strcmp("doc", argv[1]) == 0)
-	{
+	if (strcmp("doc", argv[1]) == 0) {
 		/* Need to do this in two passes.
 		 * First pass is used to collect all symbols exported
 		 * in the various files;
@@ -556,9 +553,7 @@ int main(int argc, char *argv[])
 			fprintf(stderr, "Warning: didn't use docs for %s\n",
 				all_list[i]);
 		}
-	}
-	else if (strcmp("depend", argv[1]) == 0)
-	{
+	} else if (strcmp("depend", argv[1]) == 0) {
 		/* Create first part of dependency chain
 		 * file.tmpl */
 		printf("%s\t", argv[2]);
@@ -571,9 +566,7 @@ int main(int argc, char *argv[])
 		findall           = adddep;
 		parse_file(infile);
 		printf("\n");
-	}
-	else
-	{
+	} else {
 		fprintf(stderr, "Unknown option: %s\n", argv[1]);
 		exit(1);
 	}


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

