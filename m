Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab1LLQ2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 11:28:17 -0500
Received: from mailgw9.se.ericsson.net ([193.180.251.57]:56361 "EHLO
	mailgw9.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab1LLQ2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 11:28:15 -0500
X-AuditID: c1b4fb39-b7b3eae00000252a-c5-4ee62b9d93d3
Message-ID: <4EE62B78.8090608@ericsson.com>
Date: Mon, 12 Dec 2011 17:27:36 +0100
From: Erik Hugne <erik.hugne@ericsson.com>
Organization: Ericsson AB
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kobject/kset symbols not exported
References: <4EE6237A.9010901@ericsson.com>
In-Reply-To: <4EE6237A.9010901@ericsson.com>
X-Forwarded-Message-Id: <4EE6237A.9010901@ericsson.com>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The top level module_kset, defined at:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=include/linux/module.h;h=3cb7839a60b96ffc6e4fe9b28d0ddf491275b2f6;hb=HEAD#l630

Does not have a symbol exported at:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=kernel/params.c;h=65aae11eb93f1fab5a4673ca9e9d4df9f2582e8e;hb=HEAD#l908

The same applies to two kobject related functions:

extern struct kobject *kset_find_obj(struct kset *, const char *);
extern struct kobject *kset_find_obj_hinted(struct kset *, const char *,
struct kobject *);

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=include/linux/kobject.h;h=ad81e1c51487def091ffea196d36c1ee005f7698;hb=HEAD#l193

This makes them inaccessible to modules. Is this intentional?

//E
