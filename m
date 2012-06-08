Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509Ab2FHBJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 21:09:44 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37288 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759112Ab2FHBJn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 21:09:43 -0400
MIME-Version: 1.0
In-Reply-To: <20120607180515.4afffc89.akpm@linux-foundation.org>
References: <20120608002451.GA821@redhat.com> <CA+55aFzivM8Z1Bjk3Qo2vtnQhCQ7fQ4rf_a+EXY7noXQcxL_CA@mail.gmail.com>
 <20120607180515.4afffc89.akpm@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 7 Jun 2012 18:09:20 -0700
X-Google-Sender-Auth: gL3MC4xHP2DRux2QC05jklC9D_g
Message-ID: <CA+55aFz12eeNHGt5GV_w=brPVed3Ga9HjYy73dbusEyPpX39OQ@mail.gmail.com>
Subject: Re: a whole bunch of crashes since todays -mm merge.
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 6:05 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> It appears this is due to me fat-fingering conflict resolution last
> week.  That hunk is supposed to be in mm_release(), not mmput().

Ahh. That would indeed make more sense. The mmput() placement is
insane for so many reasons.

I reverted it and pushed it out, because it clearly was horrible. Even
if it is possible that Dave's problems are due to something else (but
if they started with the mm merge, I don't see anything else nearly as
scary in there)

                    Linus
