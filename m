Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab0KKTtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:49:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756398Ab0KKTtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:49:19 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
In-Reply-To: <1289404309-15955-2-git-send-email-zohar@linux.vnet.ibm.com>
References: <1289404309-15955-2-git-send-email-zohar@linux.vnet.ibm.com> <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH v1.3 1/4] lib: hex2bin converts ascii hexadecimal string to binary
Date: Thu, 11 Nov 2010 19:48:47 +0000
Message-ID: <6640.1289504927@redhat.com>
From: David Howells <dhowells@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> +void hex2bin(unsigned char *mem, char *buf, int count)

I think this needs a little adjustment.  I would recommend something like the
following declaration:

	void hex2bin(u8 *buf, const char *data, size_t count)

since the output data is binary (so use u8*), you're only reading the source
data (so should use a const pointer) and you don't want to see a negative
count (so use size_t).

Also, I'd suggest calling the source arg 'data' and the output arg 'buf' or
maybe src/dst.

David
