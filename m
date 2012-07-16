Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab2GPRaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 13:30:20 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:41585 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752746Ab2GPRaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 13:30:13 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ISW9XGUVM1nj73E3ZO3D.nGEv05KiFXKon8FF6irnaGEiZd
 t6n5C5yCdWApFQByITssC8DvcQyWDilowHI4F7tpDDGWd8V.kkBdS6HcrFUg
 Rsm4aqyjSSV9LMyCI4Xl62ZinrHcKAWJIfMmsoeJtny99.ome973iZIzfuA1
 kYpafQUw7FnoQVFgmGMt9.A5.YnQ0WKokZgrGBzMn.bEO8Q9Qunmw12dXuOY
 sOxvZ6OdvfGJewxkVsJMm291HQn59h_tKaLR8SaVjuUoXXcg0J6WL.bwuvbN
 sCG5rN2NT8ubhQ5klGK__6DYdh5PHSKlbBNv6adgvYnXnthZVvbi9ypnQfHG
 SyOcy47k_hbWbCzlFzYf4A10ImpI4Av5dRIcX5AH8lSGMvlRnAMzES5zezx8
 _
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 16 Jul 2012 12:30:09 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Joonsoo Kim <js1304@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Brice Goglin <brice@myri.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH 4] mm: fix possible incorrect return value of move_pages()
 syscall
In-Reply-To: <1342458889-19090-1-git-send-email-js1304@gmail.com>
Message-ID: <alpine.DEB.2.00.1207161230010.32319@router.home>
References: <1342455272-32703-1-git-send-email-js1304@gmail.com> <1342458889-19090-1-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2012, Joonsoo Kim wrote:

> move_pages() syscall may return success in case that
> do_move_page_to_node_array return positive value which means migration failed.
> This patch changes return value of do_move_page_to_node_array
> for not returning positive value. It can fix the problem.
>
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
> Cc: Brice Goglin <brice@myri.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Minchan Kim <minchan@kernel.org>
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 294d52a..adabaf4 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1171,7 +1171,7 @@ set_status:
>  	}
>
>  	up_read(&mm->mmap_sem);
> -	return err;
> +	return err > 0 ? -EIO : err;
>  }

Please use EBUSY.

