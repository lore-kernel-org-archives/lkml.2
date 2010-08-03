Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab0HCVk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 17:40:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993Ab0HCVkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 17:40:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <19826.1280811821@neuling.org>
References: <19826.1280811821@neuling.org> <19789.1280811783@neuling.org>
To: Michael Neuling <mikey@neuling.org>
Cc: dhowells@redhat.com, stable@kernel.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH 2.6.32/stable] CIFS: Remove __exit mark from cifs_init_dns_resolver() header
Date: Tue, 03 Aug 2010 22:40:25 +0100
Message-ID: <12482.1280871625@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Neuling <mikey@neuling.org> wrote:

> An allmodconfig compile on ppc64 with 2.6.32.17 currently gives this error
> 
> fs/cifs/dns_resolve.h:27: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'cifs_init_dns_resolver'
> 
> This removes the __init from cifs_init_dns_resolver()

That's not really a good idea as the assembler may choose different pieces of
assembly to do variable references and jumps, depending on the section
information.

A better fix is to add:

	#include <linux/module.h>

to the header file.

David
