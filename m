Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab0KKV6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 16:58:10 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60834 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab0KKV6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 16:58:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-type:content-transfer-encoding:x-mailer
         :thread-index:content-language;
        b=ErGIKFu+SByGSdrWvd6Js19YM0jQNDEl0NqfdP2KZZqIPA9HRIupLv3qlLEwwUVTkq
         GJvSrm2LFSXWJI2t+0GI4noGbdNqpUCgLN+48vFRH/wpcgTATRZqoI8Z8qfYVufY6Sgj
         TRNLaA/oZS1s+AkTh9+HQm/1xLfQ2FSkkmBq4=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Eric Paris'" <eparis@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Cc: <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>, <pekkas@netcore.fi>,
        <jmorris@namei.org>, <yoshfuji@linux-ipv6.org>, <kaber@trash.net>
References: <20101111210341.31350.86916.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101111210341.31350.86916.stgit@paris.rdu.redhat.com>
Subject: RE: [RFC PATCH] network: return errors if we know tcp_connect failed
Date: Thu, 11 Nov 2010 13:58:02 -0800
Message-ID: <00c201cb81eb$84e18160$8ea48420$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcuB5DRKuvKYmJhvSaKUFVkWoAgbsAABpK5Q
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, I realize this is little different than if the
> SYN was dropped in the first network device, but it is different
> because we know what happened!  We know that connect() call failed
> and that there isn't anything coming back.

I would argue that -j DROP should behave exactly as the packet is dropped in the network, while -j REJECT should signal the failure to the application as soon as possible (which it doesn't seem to do).

It does not only make sense, but also is a highly useful testing technique that we use -j DROP in OUTPUT to emulate network losses and see how the application behaves.




