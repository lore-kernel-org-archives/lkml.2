Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622Ab0CaTK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 15:10:29 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:51020 "EHLO
	mx01.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756588Ab0CaTK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 15:10:27 -0400
X-Greylist: delayed 2058 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Mar 2010 15:10:27 EDT
Date: Wed, 31 Mar 2010 14:36:05 -0400 (EDT)
From: Miloslav Trmac <mitr@redhat.com>
To: Juraj Hlista <juro.hlista@gmail.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, sgrubb@redhat.com
Message-ID: <1870478057.299001270060565969.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1844882650.298781270060487513.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Subject: Re: [PATCH] audit: Reactive rules
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
----- "Juraj Hlista" <juro.hlista@gmail.com> wrote:
> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> @@ -415,7 +424,8 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
> -	int i;
> +	int i, j = 0;
> +	int k;
> @@ -425,7 +435,7 @@ static struct audit_entry
> *audit_data_to_entry(struct audit_rule_data *data,
>  	for (i = 0; i < data->field_count; i++) {
> -		struct audit_field *f = &entry->rule.fields[i];
> +		struct audit_field *f = &entry->rule.fields[i - j];
It would be more clear to have a "source index" (used for "data"), and a "destination index" (used for entry->rule.fields); "j" is currently a difference between the two.

