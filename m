Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470Ab1DMA1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 20:27:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751847Ab1DMA1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 20:27:02 -0400
Date: Tue, 12 Apr 2011 17:26:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Balbir Singh <balbir@in.ibm.com>
Subject: Re: [RFC]Documentation:accounting:getdelays.c Fix: warning:
 variable =?UTF-8?Q?=E2=80=98i=E2=80=99?= set but not used
Message-Id: <20110412172627.4e9c4339.akpm@linux-foundation.org>
In-Reply-To: <1302019370-7101-1-git-send-email-justinmattock@gmail.com>
References: <1302019370-7101-1-git-send-email-justinmattock@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  5 Apr 2011 09:02:50 -0700
"Justin P. Mattock" <justinmattock@gmail.com> wrote:

> Keep in mind there is another warning with this file, but need am unsure what might be the best solution:
> Documentation/accounting/getdelays.c: In function ___get_family_id___:
> Documentation/accounting/getdelays.c:172:14: warning: variable ___rc___ set but not used [-Wunused-but-set-variable]

this?


Subject: Documentation/accounting/getdelays.c: handle sendto() failures
From: Andrew Morton <akpm@linux-foundation.org>

Documentation/accounting/getdelays.c: In function `get_family_id':
Documentation/accounting/getdelays.c:172:14: warning: variable `rc' set but not used [-Wunused-but-set-variable]

Reported-by: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN Documentation/accounting/getdelays.c~documentation-accounting-getdelaysc-handle-sendto-failures Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~documentation-accounting-getdelaysc-handle-sendto-failures
+++ a/Documentation/accounting/getdelays.c
@@ -177,6 +177,8 @@ static int get_family_id(int sd)
 	rc = send_cmd(sd, GENL_ID_CTRL, getpid(), CTRL_CMD_GETFAMILY,
 			CTRL_ATTR_FAMILY_NAME, (void *)name,
 			strlen(TASKSTATS_GENL_NAME)+1);
+	if (rc < 0)
+		return 0;	/* sendto() failure? */
 
 	rep_len = recv(sd, &ans, sizeof(ans), 0);
 	if (ans.n.nlmsg_type == NLMSG_ERROR ||
_

