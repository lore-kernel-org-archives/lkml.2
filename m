Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216Ab2CGXx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 18:53:28 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:53286 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758862Ab2CGXx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 18:53:26 -0500
Date: Wed, 7 Mar 2012 15:53:23 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: decode GFP flags in oom killer output.
In-Reply-To: <20120307233939.GB5574@redhat.com>
Message-ID: <alpine.DEB.2.00.1203071548200.29642@chino.kir.corp.google.com>
References: <20120307233939.GB5574@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012, Dave Jones wrote:

> Decoding these flags by hand in oom reports is tedious,
> and error-prone.
> 

Something like this is already done in include/trace/events/gfpflags.h so 
there should be a generic version of this or something you can already 
use.

The problem here is that you have to allocate an additional 80-bytes for 
the string and the oom killer is notorious for being called deep in the 
stack and you can't statically allocate a string buffer without adding 
additional syncronization.
