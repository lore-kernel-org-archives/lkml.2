Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab1H3NNB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 09:13:01 -0400
Received: from mx1.etf.rs ([147.91.14.169]:38363 "EHLO mx1.etf.bg.ac.rs"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab1H3NM6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 09:12:58 -0400
Message-ID: <59e0c7c0ba5282f35b101e7058fb27fa.squirrel@kondor.etf.bg.ac.rs>
Date: Tue, 30 Aug 2011 15:12:55 +0200
Subject: [PATCH] cls_rsvp.h was outdated
From: =?utf-8?B?Iklnb3IgTWFyYXZpxIci?= <igorm@etf.rs>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reply-To: igorm@etf.rs
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
X-Priority: 3 (Normal)
Importance: Normal
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File cls_rsvp.h in /net/sched was outdated. I'm sending you patch for this
file.

Sorry for the word-wrap in previous messages

Signed-off-by: Igor Maravić <igorm@etf.rs>

---

--- linux-2.6.38.8/net/sched/cls_rsvp.h.orig	2011-08-30 12:46:42.663443918 +0200
+++ linux-2.6.38.8/net/sched/cls_rsvp.h	2011-08-30 13:45:02.135445119 +0200
@@ -425,7 +425,7 @@ static int rsvp_change(struct tcf_proto
 	struct rsvp_filter *f, **fp;
 	struct rsvp_session *s, **sp;
 	struct tc_rsvp_pinfo *pinfo = NULL;
-	struct nlattr *opt = tca[TCA_OPTIONS-1];
+	struct nlattr *opt = tca[TCA_OPTIONS];
 	struct nlattr *tb[TCA_RSVP_MAX + 1];
 	struct tcf_exts e;
 	unsigned h1, h2;
@@ -439,7 +439,7 @@ static int rsvp_change(struct tcf_proto
 	if (err < 0)
 		return err;

-	err = tcf_exts_validate(tp, tb, tca[TCA_RATE-1], &e, &rsvp_ext_map);
+	err = tcf_exts_validate(tp, tb, tca[TCA_RATE], &e, &rsvp_ext_map);
 	if (err < 0)
 		return err;

@@ -448,8 +448,8 @@ static int rsvp_change(struct tcf_proto

 		if (f->handle != handle && handle)
 			goto errout2;
-		if (tb[TCA_RSVP_CLASSID-1]) {
-			f->res.classid = nla_get_u32(tb[TCA_RSVP_CLASSID-1]);
+		if (tb[TCA_RSVP_CLASSID]) {
+			f->res.classid = nla_get_u32(tb[TCA_RSVP_CLASSID]);
 			tcf_bind_filter(tp, &f->res, base);
 		}

@@ -461,7 +461,7 @@ static int rsvp_change(struct tcf_proto
 	err = -EINVAL;
 	if (handle)
 		goto errout2;
-	if (tb[TCA_RSVP_DST-1] == NULL)
+	if (tb[TCA_RSVP_DST] == NULL)
 		goto errout2;

 	err = -ENOBUFS;
@@ -470,19 +470,19 @@ static int rsvp_change(struct tcf_proto
 		goto errout2;

 	h2 = 16;
-	if (tb[TCA_RSVP_SRC-1]) {
-		memcpy(f->src, nla_data(tb[TCA_RSVP_SRC-1]), sizeof(f->src));
+	if (tb[TCA_RSVP_SRC]) {
+		memcpy(f->src, nla_data(tb[TCA_RSVP_SRC]), sizeof(f->src));
 		h2 = hash_src(f->src);
 	}
-	if (tb[TCA_RSVP_PINFO-1]) {
-		pinfo = nla_data(tb[TCA_RSVP_PINFO-1]);
+	if (tb[TCA_RSVP_PINFO]) {
+		pinfo = nla_data(tb[TCA_RSVP_PINFO]);
 		f->spi = pinfo->spi;
 		f->tunnelhdr = pinfo->tunnelhdr;
 	}
-	if (tb[TCA_RSVP_CLASSID-1])
-		f->res.classid = nla_get_u32(tb[TCA_RSVP_CLASSID-1]);
+	if (tb[TCA_RSVP_CLASSID])
+		f->res.classid = nla_get_u32(tb[TCA_RSVP_CLASSID]);

-	dst = nla_data(tb[TCA_RSVP_DST-1]);
+	dst = nla_data(tb[TCA_RSVP_DST]);
 	h1 = hash_dst(dst, pinfo ? pinfo->protocol : 0, pinfo ? pinfo->tunnelid : 0);

 	err = -ENOMEM;
@@ -641,8 +641,7 @@ nla_put_failure:
 	return -1;
 }

-static struct tcf_proto_ops RSVP_OPS = {
-	.next		=	NULL,
+static struct tcf_proto_ops RSVP_OPS __read_mostly = {
 	.kind		=	RSVP_ID,
 	.classify	=	rsvp_classify,
 	.init		=	rsvp_init,



