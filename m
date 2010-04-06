Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab0DFC7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 22:59:09 -0400
Received: from mail-yx0-f200.google.com ([209.85.210.200]:39292 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168Ab0DFC6t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 22:58:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=lBff6kIMWJUaMbgwd1qp1n2GMqdwLWVxudhk9hgbdIjXGay2p+dYVbmPSJoR1OVAo6
         y7tys0ErjjhQlF98MoSmkivX9QZIUMSAyn0uTIuELpUcfP6D37a5BADlvQPqNGi/Gexv
         16O2pahI3fpgLu6X0pGpUnZzu3HK5/YTySk1A=
MIME-Version: 1.0
In-Reply-To: <20100406025020.GA2741@localhost.localdomain>
References: <20100406025020.GA2741@localhost.localdomain>
From: Changli Gao <xiaosuo@gmail.com>
Date: Tue, 6 Apr 2010 10:58:28 +0800
Message-ID: <k2l412e6f7f1004051958h7c50f439r6b7a84379c35cba5@mail.gmail.com>
Subject: Re: [PATCH] IPVS: replace sprintf to snprintf to avoid stack buffer 
	overflow
To: wzt.wzt@gmail.com
Cc: linux-kernel@vger.kernel.org, wensong@linux-vs.org, netdev@vger.kernel.org,
       lvs-devel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 6, 2010 at 10:50 AM,  <wzt.wzt@gmail.com> wrote:
> IPVS not check the length of pp->name, use sprintf will cause stack buffer overflow.
> struct ip_vs_protocol{} declare name as char *, if register a protocol as:
> struct ip_vs_protocol ip_vs_test = {
>        .name =                 "aaaaaaaa....128...aaa",
>        .debug_packet =         ip_vs_tcpudp_debug_packet,
> };
>
> when called ip_vs_tcpudp_debug_packet(), sprintf(buf, "%s TRUNCATED", pp->name);
> will cause stack buffer overflow.
>

Long messages will be truncated instead of buffer overflow. We need to
find a way to handle long messages elegantly.

-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
