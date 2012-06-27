Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757Ab2F0EXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 00:23:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34713 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab2F0EXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 00:23:07 -0400
Date: Tue, 26 Jun 2012 21:23:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Wen Congyang <wency@cn.fujitsu.com>
cc: lenb@kernel.org, linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH 5/8] don't print message if request_resource() failed
In-Reply-To: <4FE97F13.3000804@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1206262122160.24245@chino.kir.corp.google.com>
References: <4FE97DD5.6030205@cn.fujitsu.com> <4FE97F13.3000804@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2012, Wen Congyang wrote:

> If register_memory_resource() fails, the caller(add_memory()) will
> return -EEXIST, and add_memory() returns -EEXIST only when
> register_memory_resource() fails. The function acpi_memory_enable_device()
> doesn't treat such erro as a fetal error, and don't want this message.
> The function that calls add_memory() has printed message if add_memory()
> failed, so don't print message in register_memory_resource().
> 

That may be true for acpi_memory_enable_device(), but have you checked 
other callers to add_memory()?
