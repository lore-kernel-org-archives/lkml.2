Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061Ab0KLXOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 18:14:24 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59534 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932584Ab0KLXOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 18:14:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-type:content-transfer-encoding:x-mailer
         :thread-index:content-language;
        b=AqyTxEWcl8TX0JZ2WuhgjbnyglfNDIhsIVvtknrQHI9QMEHpu09vWQ87ie0ko8J8Ci
         +AT2vR7VyO6SvELlNOE/nT/etxn/QBk6cpu6j86xUhUCQ58gz9zuejwFLGUrV4jBhRB+
         HmKSEJvssjDkI6gDNuHZmdpxw8p8ZxFgB9EgQ=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Patrick McHardy'" <kaber@trash.net>
Cc: "'Eric Paris'" <eparis@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
        <kuznet@ms2.inr.ac.ru>, <pekkas@netcore.fi>, <jmorris@namei.org>,
        <yoshfuji@linux-ipv6.org>
References: <20101111210341.31350.86916.stgit@paris.rdu.redhat.com> <00c201cb81eb$84e18160$8ea48420$@com> <4CDCEE65.3060105@trash.net>
In-Reply-To: <4CDCEE65.3060105@trash.net>
Subject: RE: [RFC PATCH] network: return errors if we know tcp_connect failed
Date: Fri, 12 Nov 2010 15:14:14 -0800
Message-ID: <017301cb82bf$54540cf0$fcfc26d0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcuCPENcdK9K1ZCcQ5iGRtNdAGafAgAgvlaQ
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 11.11.2010 22:58, Hua Zhong wrote:
> >> Yes, I realize this is little different than if the
> >> SYN was dropped in the first network device, but it is different
> >> because we know what happened!  We know that connect() call failed
> >> and that there isn't anything coming back.
> >
> > I would argue that -j DROP should behave exactly as the packet is
> dropped in the network, while -j REJECT should signal the failure to
> the application as soon as possible (which it doesn't seem to do).
> 
> It sends an ICMP error or TCP reset. Interpretation is up to TCP.

Huh? It's the OUTPUT chain we are talking about. There is no ICMP error or
TCP reset.

