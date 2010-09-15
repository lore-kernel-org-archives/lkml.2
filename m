Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab0IOQHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 12:07:19 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:43891 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab0IOQHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 12:07:15 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Christopher Yeoh <cyeoh@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Cross Memory Attach
In-Reply-To: Your message of "Wed, 15 Sep 2010 10:48:55 +0930."
             <20100915104855.41de3ebf@lilo>
From: Valdis.Kletnieks@vt.edu
References: <20100915104855.41de3ebf@lilo>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1284566831_4463P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 15 Sep 2010 12:07:11 -0400
Message-ID: <10951.1284566831@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4C90EF2F.01DD,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1284566831_4463P
Content-Type: text/plain; charset=us-ascii

On Wed, 15 Sep 2010 10:48:55 +0930, Christopher Yeoh said:

> The basic idea behind cross memory attach is to allow MPI programs doing
> intra-node communication to do a single copy of the message rather than
> a double copy of the message via shared memory.

Interesting, and nice benchmark results.  I have a question though:

> +	/* Get the pages we're interested in */
> +	pages_pinned = get_user_pages(task, task->mm, pa,
> +				      nr_pages_to_copy,
> +				      copy_to, 0, process_pages, NULL);
> +
> +	if (pages_pinned != nr_pages_to_copy)
> +		goto end;

...

> +end:
> +	for (i = 0; i < pages_pinned; i++) {
> +		if (copy_to)
> +			set_page_dirty_lock(process_pages[i]);
> +		put_page(process_pages[i]);
> +	}

It looks to me like if get_user_pages() fails to pin *all* the pages, we treat
the target pages as dirty even though we never actually touched them?

Maybe it should be 'if (copy_to && *bytes_copied)'?

--==_Exmh_1284566831_4463P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMkO8vcC3lWbTT17ARAsL+AKDve22aLS7kW0anPfzl6xLNU6LMmQCfSbY1
UxVIjtAK9DbhXaUNwVXiuGg=
=Muy5
-----END PGP SIGNATURE-----

--==_Exmh_1284566831_4463P--

