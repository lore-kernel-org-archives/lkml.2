Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819Ab2FFWHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 18:07:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35227 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab2FFWHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 18:07:08 -0400
Date: Wed, 6 Jun 2012 15:05:29 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Bryan Freed <bfreed@chromium.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, marco.stornelli@gmail.com,
        grant.likely@secretlab.ca
Subject: Re: [PATCH] pstore/ram: Add ramoops support for the Flattened Device
 Tree.
Message-ID: <20120606220528.GA4010@lizard>
References: <1338926395-26298-1-git-send-email-bfreed@chromium.org>
 <4FCF9053.6020102@codeaurora.org>
 <CAEYUcX33J4VjFOc1qLi7TZQ6B8ugc0Yky=pm1yPJXqi=SfZPBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAEYUcX33J4VjFOc1qLi7TZQ6B8ugc0Yky=pm1yPJXqi=SfZPBA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 11:00:27AM -0700, Bryan Freed wrote:
[...]
> Anyone have a strong feeling on dev_err vs pr_err and how/if this
> transition should occur?

If you have a device, it's better to use dev_*(), since that way
you'll get more information in the logs, e.g. which exact device
caused the issue.

But this makes sense only for drivers that support multiple
devices. Not the case for pstore now, though this might change
in the future. (E.g. we might have several pstore nodes some day.)

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
