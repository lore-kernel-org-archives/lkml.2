Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab1AZNkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 08:40:36 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:59816 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab1AZNke convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 08:40:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kCSJ8msFg+3oa+XutMNKXTiNuBHmqy0wzrZ/vvoJZgUpAxH0DZYdQDnHypG/aWSSOg
         4MHncvsMXvFh5AyzXvlMA/l9OEBVA/B9u5ramGyb+gmlJKxuIip8YsOgg4GA/rC+WhSZ
         tGNt/RsnA7Hbgol4dyB2DDO1GWPVxFlHKC+Yw=
MIME-Version: 1.0
In-Reply-To: <1296030555-3594-1-git-send-email-gthelen@google.com>
References: <1296030555-3594-1-git-send-email-gthelen@google.com>
Date: Wed, 26 Jan 2011 19:10:34 +0530
X-Google-Sender-Auth: DK2i77fr9rYG8nNhuz2tNwWxCcU
Message-ID: <AANLkTikZwbmVr-jvOoyd0WZhfxtHvqK=n1B-zWLr3xDa@mail.gmail.com>
Subject: Re: [PATCH] oom: handle overflow in mem_cgroup_out_of_memory()
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 1:59 PM, Greg Thelen <gthelen@google.com> wrote:
> mem_cgroup_get_limit() returns a byte limit as a unsigned 64 bit value,
> which is converted to a page count by mem_cgroup_out_of_memory().  Prior
> to this patch the conversion could overflow on 32 bit platforms
> yielding a limit of zero.
>

Why would the overflow occur? Due to the right shift being used with
unsigned long long? I am afraid I don't have quick access to a 32 bit
box to test the patch. May be I too drained to understand the problem,
can you post the corresponding assembly for analysis?

Balbir
