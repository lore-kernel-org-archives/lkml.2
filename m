Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759662Ab0J2AHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 20:07:08 -0400
Received: from smtp-out.google.com ([74.125.121.35]:18577 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758557Ab0J2AHF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 20:07:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iw6MXIvH2k1R98Znx+Obf9EmOYw0BVecl0Ir8D2Tbw3mU9w9W9Yw0m01SGv+9nyDBZ
         yxXSkHAhqOMcIoYFbqtg==
MIME-Version: 1.0
In-Reply-To: <20101022214650.GL10119@count0.beaverton.ibm.com>
References: <4CC146A4.9090505@cn.fujitsu.com>
	<4CC1473D.9070201@cn.fujitsu.com>
	<20101022205755.GJ10119@count0.beaverton.ibm.com>
	<20101022214650.GL10119@count0.beaverton.ibm.com>
Date: Thu, 28 Oct 2010 17:06:59 -0700
Message-ID: <AANLkTimmcVdF4Vmv8BuBNmvpGvvW2eDKC1g5XEYY7Jip@mail.gmail.com>
Subject: Re: [PATCH 5/7] cgroups: Make freezer subsystem bindable
From: Paul Menage <menage@google.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        "akpm >> Andrew Morton" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 2:46 PM, Matt Helsley <matthltc@us.ibm.com> wrote:
>> Alternately you could split the bind/unbind op function pointers
>> and get rid of the boolean argument. Then just don't fill in the
>> freezer's unbind op and refuse to unbind subsystems that lack
>> the unbind op. That seems a bit cleaner for now at least.
>
> Or alternately to the alternate :):  add a can_unbind:1 field and keep
> the boolean bind op argument. That might be best -- avoids an extra
> function pointer and still splits the bind/unbind-ability of a
> subsystem.

I think I'd vote for the separate bind() / unbind() callbacks.

Paul
