Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab2JTQ5j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 12:57:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007Ab2JTQ5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 12:57:38 -0400
Message-ID: <5081B7F8.7040302@draigBrady.com>
Date: Fri, 19 Oct 2012 13:28:40 -0700
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: abhishek agarwal <abhigem.126@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [Perf] Adding timeout option
References: <CAMjzKwXZLGX7EM7dVOHWcN-8Ay40bbhiR4v5M352Xd2g2uHY1g@mail.gmail.com>
In-Reply-To: <CAMjzKwXZLGX7EM7dVOHWcN-8Ay40bbhiR4v5M352Xd2g2uHY1g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2012 08:54 AM, abhishek agarwal wrote:
> Hi folks..
>
> I was thinking that why cant we have a timeout option in perf stat
> command.  The timeout feature will help us to profile a process for a
> stipulated time (preferably in millisecs) and make perf stat return
> after that time.
> Eg:
>
> perf stat --timeout=10 sleep 100
>
> This will make perf return and report stats after 10 ms...
>
> Hope anyone can shed some more light on the idea

It seems preferable to use the timeout program to do this.
Either sending a handled signal to the perf process like:

     timeout -s HUP 10 perf stat sleep 100

Or even better, just use that to kill the monitored process itself

     perf stat timeout 10 sleep 100

cheers,
Pádraig.
