Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab1LTIQC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 03:16:02 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42374 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab1LTIP5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 03:15:57 -0500
MIME-Version: 1.0
In-Reply-To: <2de3288bd94ae76c7a7d7486b94e2e59e5ca97a8.1324318997.git.jbaron@redhat.com>
References: <cover.1324318997.git.jbaron@redhat.com>
	<2de3288bd94ae76c7a7d7486b94e2e59e5ca97a8.1324318997.git.jbaron@redhat.com>
Date: Tue, 20 Dec 2011 08:15:55 +0000
X-Google-Sender-Auth: nHQFn4Ly-opezCduI8NMwb1JEm8
Message-ID: <CAO+b5-od4CFkJkxQKoXq4e85XeKq9VFX2kh5FbT7_JMSgFX=JQ@mail.gmail.com>
Subject: Re: [PATCH 14/16] dynamic_debug: add trim_prefix() to provide
 source-root relative paths
From: Bart Van Assche <bvanassche@acm.org>
To: Jason Baron <jbaron@redhat.com>
Cc: greg@kroah.com, jim.cromie@gmail.com, joe@perches.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 10:13 PM, Jason Baron <jbaron@redhat.com> wrote:
> +/* Return the path relative to source root */
> +static inline const char *trim_prefix(const char *path)
> +{
> +       int skip = strlen(__FILE__) - strlen("lib/dynamic_debug.c");
> +
> +       if (strncmp(path, __FILE__, skip))
> +               skip = 0; /* prefix mismatch, don't skip */
> +
> +       return path + skip;
> +}

Isn't the preferred style to write if (strncmp(...) != 0) ..., i.e. to
mention "!= 0" explicitly instead of leaving it out when comparing
strings ?

Bart.
