Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387Ab1AKW64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 17:58:56 -0500
Received: from web33006.mail.mud.yahoo.com ([209.191.69.121]:21981 "HELO
	web33006.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754686Ab1AKW6y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 17:58:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=c77qR5bdQMOS6O1c2D2VGj+NuRGLgpo4pwotZM1H+mmywTpwgSp/2HNOQv2OYRWkhuGdpaQLuhxYOjlLqjL2TmmTD0bxGBQFVcc0oDfl9WajBCSoL5A33/lO+xdQNuj5jpez9/d2qb4ZHtZRCkHHlrUzFDEzeBAyeCwpel5DE0w=;
Message-ID: <877909.84984.qm@web33006.mail.mud.yahoo.com>
X-YMail-OSG: cf_ifbIVM1mfx.CyVz3hG3b0O0lwQkYyzVdzqZ.As9ZxX3F
 z3fQdihLCF7WiP0nRXZZCGjRcMnIPmXRR1Gc4O1CTqUSRpbh8V0YiPylTR1i
 JRyZkVZ.mJO3DjYhMdiRt.VPRBmY7UdvhJtoHvhDUVVN7rG7XznxCltqkJYG
 MbycqEAs4rD7Cp9rVSbVy62UkoO8grH2GuCtH6crBVNumrlldOgHMzYFnClh
 seoA7mvggXRWenX0i6Xe5ZiYcerOx_BDYYbz_KzZHdozD9NuYtpED794n2Ie
 6r3FNOheOYUo8V2g284iHrYY5exG9SxrsxHhD98XsZ6ShhK_ycm94u.COKRy
 Qs0j2IqQgKz_qhjS53K9uF24Zaalmc8DkvvyA4VtRXplWlbPpocDg2Wfl5Q4
 vv2X7DFTh4w--
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Tue, 11 Jan 2011 14:52:11 -0800 (PST)
From: Stephen Cameron <smcameron@yahoo.com>
Subject: Re: [PATCH] hpsa: do not re-order commands in internal queues
To: james.bottomley@hansenpartnership.com,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, mike.miller@hp.com,
        linux-kernel@vger.kernel.org, thenzl@redhat.com,
        akpm@linux-foundation.org
In-Reply-To: <20110111224658.24457.62925.stgit@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Tue, 1/11/11, Stephen M. Cameron <scameron@beardog.cce.hp.com> wrote:

[...]
> @@ -2837,8 +2837,8 @@ static void start_io(struct ctlr_info
> *h)
>  {
>      struct CommandList *c;
>  
> -    while (!hlist_empty(&h->reqQ))
> {
> -        c =
> hlist_entry(h->reqQ.first, struct CommandList, list);
> +    while (!list_empty(&h->reqQ)) {
> +        c =
> list_entry(h->reqQ.first, struct CommandList, list);


No, I screwed this up.  Disregard this patch.

-- steve




      
