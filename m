Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab0KIVFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:05:35 -0500
Received: from smtp-out.google.com ([74.125.121.35]:51654 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab0KIVFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:05:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ScKHEpyDv+Rp6wZYSax8T6EtNWS8NvbiFwpZHBhDBuvywKZqbg9F1PZondKu/tRwDv
         hVFQEKF+PgMDROoPKRHQ==
MIME-Version: 1.0
In-Reply-To: <4CD78946.5060405@cn.fujitsu.com>
References: <4CC146A4.9090505@cn.fujitsu.com>
	<4CC146BA.7080009@cn.fujitsu.com>
	<AANLkTikf-1kLStxqi5UjP=vn3pqVBHy0OA7ibeWTkJ5z@mail.gmail.com>
	<4CD78946.5060405@cn.fujitsu.com>
Date: Tue, 9 Nov 2010 13:05:31 -0800
Message-ID: <AANLkTim6d1fQLZbkmZST3PTN0RMSs3m=oossF81pYBn9@mail.gmail.com>
Subject: Re: [PATCH 1/7] cgroups: Shrink struct cgroup_subsys
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "akpm >> Andrew Morton" <akpm@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 7, 2010 at 9:23 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> bool active;
> bool disabled;
> ...
>
> ?
>
> With alignment 5-8 bool values == 8 bytes in 64-bit machine, compared to
> 4 bytes with the approach this patch takes.

I meant specifying it as:

bool active:1;
bool disabled:1;

i.e. keeping the bit-sized flags but also keeping the bool semantics.
Having said that, I'm not really sure why saving 12 bytes per
subsystem is worth a patch.

Paul
