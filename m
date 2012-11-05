Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab2KEDby (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 22:31:54 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49626 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab2KEDbx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 22:31:53 -0500
MIME-Version: 1.0
In-Reply-To: <CAA_GA1d-rw_vkDF98fcf9E0=h86dsp+83-0_RE5b482juxaGVw@mail.gmail.com>
References: <508086DA.3010600@oracle.com>
	<5089A05E.7040000@gmail.com>
	<CA+1xoqf2v_jEapwU68BzXyi4abSRmi_=AiaJVHM3dBbHtsBnqQ@mail.gmail.com>
	<CAA_GA1d-rw_vkDF98fcf9E0=h86dsp+83-0_RE5b482juxaGVw@mail.gmail.com>
Date: Sun, 4 Nov 2012 19:31:52 -0800
Message-ID: <CANN689HXoCMTP4ZRMUNOGAdOBmizKyo6jMqbqAFx8wwPXp+AzQ@mail.gmail.com>
Subject: Re: mm: NULL ptr deref in anon_vma_interval_tree_verify
From: Michel Lespinasse <walken@google.com>
To: Bob Liu <lliubbo@gmail.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, hughd@google.com,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 4, 2012 at 6:20 PM, Bob Liu <lliubbo@gmail.com> wrote:
> The loop for each entry of vma->anon_vma_chain in validate_mm() is not
> protected by anon_vma lock.
> I think that may be the cause.
>
> Michel, What's your opinion？

Good catch, I think that's it. Somehow it had not occured to me to
verify the checker code - as in, who's checking the checker ? :)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
