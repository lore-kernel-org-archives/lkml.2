Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab2ALJHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 04:07:43 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63429 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab2ALJHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 04:07:36 -0500
Message-ID: <4F0EA367.8060105@cn.fujitsu.com>
Date: Thu, 12 Jan 2012 17:09:59 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: David Rientjes <rientjes@google.com>,
        Sasha Levin <levinsasha928@gmail.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: Don't warn if memdup_user fails
References: <1326300636-29233-1-git-send-email-levinsasha928@gmail.com>	<alpine.DEB.2.00.1201111346180.21755@chino.kir.corp.google.com>	<alpine.LFD.2.02.1201120842140.2054@tux.localdomain> <CAOJsxLGTO8=w8nYADY9hVBs_63UGR-jfrPOYsgexDUo-pPFjDQ@mail.gmail.com>
In-Reply-To: <CAOJsxLGTO8=w8nYADY9hVBs_63UGR-jfrPOYsgexDUo-pPFjDQ@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-12 17:06:27,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-12 17:06:30,
	Serialize complete at 2012-01-12 17:06:30
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On Thu, Jan 12, 2012 at 8:43 AM, Pekka Enberg <penberg@kernel.org> wrote:
>> Sasha, I suppose strndup_user() has the same kind of issue?
> 
> Oh, it uses memdup_user() internally. Sorry for the noise.
> 

Before memdup_user() was introduced, strndup_user() called kmalloc()
directly, without specifying __GFP_NOWARN.
