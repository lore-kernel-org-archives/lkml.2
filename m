Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab2KROEz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 09:04:55 -0500
Received: from science.horizon.com ([71.41.210.146]:54586 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751900Ab2KROEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 09:04:54 -0500
Date: 18 Nov 2012 09:04:53 -0500
Message-ID: <20121118140453.2032.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, namit2010@gmail.com
Subject: Re: [PATCH] Lib:The patch include fix for "-" during string to long conversion
Cc: akpm@linux-foundation.org, andrei.emeltchenko@intel.com,
        andriy.shevchenko@linux.intel.com, jbeulich@suse.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAKMXDJXktVEK1XFa0P+O_EHkt6Uvb9f8UcdasaNyCLPZ+G-GcQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namit Gupta wrote:
> @@ -91,10 +98,18 @@ EXPORT_SYMBOL(simple_strtol);
>   */
>  long long simple_strtoll(const char *cp, char **endp, unsigned int base)
>  {
> 
>      long l;
>  
>      if (cp[0] != '-')
>          return simple_strtoull(cp, endp, base);
>      l = -simple_strtoull(cp+1, endp, base);

In addition to the somewhat ugly the leading blank line,
I'd call this not very well tested.
