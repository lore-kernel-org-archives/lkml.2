Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937Ab0CXUgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 16:36:44 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:36831 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932739Ab0CXUgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 16:36:41 -0400
Date: Wed, 24 Mar 2010 21:36:34 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC 07/15] PM / Hibernate: add sws_modules_ops
Message-ID: <20100324203634.GH5798@elf.ucw.cz>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz>
 <1269361063-3341-7-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269361063-3341-7-git-send-email-jslaby@suse.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2010-03-23 17:17:35, Jiri Slaby wrote:
> For now they will only hold swap operations. In next patches, user
> support will be converted to ops as well to have a single layer and
> can push pages instead of pulling them.

> +struct sws_module_ops {
> +	unsigned long (*storage_available)(void);
> +
> +	int (*get_reader)(unsigned int *flags_p);
> +	int (*put_reader)(void);
> +	int (*get_writer)(void);
> +	int (*put_writer)(unsigned int flags, int error);
> +	int (*read_page)(void *addr, struct bio **bio_chain);
> +	int (*write_page)(void *addr, struct bio **bio_chain);
> +};

sws_ prefix is strange.

Plus, could we get some docs what it does? Stuff like "get_writer" is
not entirely self-documenting.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
