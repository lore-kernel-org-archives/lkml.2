Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761953Ab2COOCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:02:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56567 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab2COOCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:02:21 -0400
Message-ID: <4F61F5E6.8060509@zytor.com>
Date: Thu, 15 Mar 2012 07:00:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, matt.fleming@intel.com
Subject: Re: [PATCH] EFI: Only set regions uncacheable if they support it
References: <1331819798-1955-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1331819798-1955-1-git-send-email-mjg@redhat.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2012 06:56 AM, Matthew Garrett wrote:
> The EFI memory region attributes field indicates whether the region can
> be mapped with various cache attributes. Our current implementation always
> marks regions uncacheable if they don't have the writeback support flag.
> This causes us to mark some regions uncacheable even if they don't
> indicate support for being uncacheable, triggering a clflush that may cause
> an MCE. Ensure we only do this for regions which support it.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Could you be specific as to what you're seeing in the field?  In
particular, what *do* these memory regions claim to support?

	-hpa

