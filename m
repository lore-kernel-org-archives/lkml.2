Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030259Ab2GDKky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 06:40:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52220 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933477Ab2GDKkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 06:40:52 -0400
Subject: Re: [PATCH 08/10] perf, tool: Add sysfs read file interface
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1341352848-11833-9-git-send-email-jolsa@redhat.com>
References: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
	 <1341352848-11833-9-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jul 2012 12:40:40 +0200
Message-ID: <1341398440.2507.100.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 00:00 +0200, Jiri Olsa wrote:
> +int sysfs_read_file(const char *file, char *buf, size_t size)
> +{
> +       char path[PATH_MAX];
> +       FILE *fp;
> +       int ret = 0;
> +
> +       snprintf(path, PATH_MAX, "%s/%s", sysfs_mountpoint, file);
> +
> +       fp = fopen(path, "r");
> +       if (!fp)
> +               return -errno;
> +
> +       if (fread(buf, 1, size, fp) == 0)
> +               ret = -errno;
> +
> +       fclose(fp);
> +       return ret; 

Does sysfs guarantee a single read is complete? If not, we need a while
loop around that read until EOF or size.

