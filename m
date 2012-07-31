Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab2GaOEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:04:49 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:42807 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751710Ab2GaOEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:04:48 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: GXemR0gVM1nSxg4DnwQKUWvhUC2L81i6GbBvfXbQkqZHzOE
 tU4rCa8Z7Ol_gp9OXjgdrQ5Lw54Bnuby8L8RHx5kkTOTzpDbhdWJ_oTNjLsk
 2_cEUpEFo6Son65EY5_jrUBYFntcIfGtwnwSUD25jX0t0eGHENFaYgecB6Yb
 S4hFPk6CjByxFX22TF9uLV0CvDXhUqjPUY.KGiGgwv0yWfes5JOzMc4.mH.Y
 hchre_5QcrNn4F2TVGS9m3YmWL9vr5BArXums1W5zIz210i3JwhdaD_caFhB
 WpeeUj2kGxaJOZ9uwyvLXofaPeaO0zqzMkQLz_KiBBAYFRO_vDoT8BBVUjr2
 YxOUTwOTV2LoNHRYwmW4dfuHRc1V9I8_vtSYau1LU50ODDH45s9enm8Y995A
 Wp5ZbSOk4dHlCpg8Bfsq4VIBE0lDPt2b6npaL03SDT86CISkLr0Y-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 31 Jul 2012 09:04:44 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: JoonSoo Kim <js1304@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Brice Goglin <brice@myri.com>,
        Minchan Kim <minchan@kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [RESEND PATCH 4/4 v3] mm: fix possible incorrect return value
 of move_pages() syscall
In-Reply-To: <CAAmzW4P6rqywK89q71DXzumREsJNGq0O4RrfdiHP2thrRSy9Gg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1207310903290.32295@router.home>
References: <1343411703-2720-1-git-send-email-js1304@gmail.com> <1343411703-2720-4-git-send-email-js1304@gmail.com> <alpine.DEB.2.00.1207271550190.25434@router.home> <CAAmzW4MdiJOaZW_b+fz1uYyj0asTCveN=24st4xKymKEvkzdgQ@mail.gmail.com>
 <alpine.DEB.2.00.1207301425410.28838@router.home> <CAAmzW4P6rqywK89q71DXzumREsJNGq0O4RrfdiHP2thrRSy9Gg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2012, JoonSoo Kim wrote:

> In man page, there is following statement.
> "status is an array of integers that return the status of each page.  The array
> only contains valid values if move_pages() did not return an error."

> And current implementation of move_pages() syscall doesn't return the number
> of pages not moved, just return 0 when it encounter some failed pages.
> So, if u want to fix the man page, u should fix do_pages_move() first.

Hmm... Yeah actually that is sufficient since the status is readily
obtainable from the status array. It would be better though if the
function would return the number of pages not moved in the same way as
migrate_pages().



