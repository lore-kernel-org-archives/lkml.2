Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab2KBVcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 17:32:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab2KBVcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 17:32:51 -0400
Date: Fri, 2 Nov 2012 14:32:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jan Beulich" <JBeulich@suse.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sscanf: don't ignore field widths for numeric
 conversions
Message-Id: <20121102143247.6c581e16.akpm@linux-foundation.org>
In-Reply-To: <5093EA4802000078000A61D4@nat28.tlf.novell.com>
References: <5093EA4802000078000A61D4@nat28.tlf.novell.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Nov 2012 14:44:08 +0000
"Jan Beulich" <JBeulich@suse.com> wrote:

> This is another step towards better standard conformance. Rather than
> adding a local buffer to store the specified portion of the string
> (with the need to enforce an arbitrary maximum supported width to
> limit the buffer size), do a maximum width conversion and then drop as
> much of it as is necessary to meet the caller's request.
> 
> Also fail on negative field widths.
> 
> ...
>
> +				simple_strtol(str, &next, base) :

simple_strtol() kerndoc says "This function is obsolete.  Please use
kstrtol instead."  Can we?

