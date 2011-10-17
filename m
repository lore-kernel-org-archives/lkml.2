Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab1JQScL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:32:11 -0400
Received: from nm11.bullet.mail.sp2.yahoo.com ([98.139.91.81]:43903 "HELO
	nm11.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752548Ab1JQScJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:32:09 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 459590.95145.bm@omp1048.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=MDrtFTRXJ5kWvNVNqwAYs9Kziet6QfOWuoZEUStIABsZdYS1FObOH88p8fYg4fqU1bUbVNrdZEMMtRmt7HIJCPXtzSR/Wu2B98asAVIXhjAKHBgW3xgGkX+v9O+JTUHz9SK6BsjvPMYGyG+1j9lEy9LVaegTdQEX5k0zgtlcAYU=;
X-YMail-OSG: aftjMvoVM1keMuaCGSyWR_DDCvvTYOy.lfVS6GLibfw0dNp
 CwJsq9h4iVgKlq4wbJC7CanlzI21hcXQi0FzQJ33wLvPatFZqdHWV8OhqgdS
 Ga4ubWJa2RWEZA1..jrsXtddWHMMhuvnlT9SxWPquKznvCv8zsdpgKN6SC4N
 TQ8MTyHBUvT6RHjASZQdQqxIXLiAXgKMxCYRv7YMFizv7r2dwUHNTjfWwZt1
 qJw6QV4FMrlhA4qqMc_weq.XgKZD6PtHeV.9eE.295ssVjmvftDpuB_tj2bp
 nvMTCo2Ser9M.ba4E98XxO7gxe2da1jPucmeW010uS1xRoPNZ8Gd5BxKcQig
 .c6gQGMSbvwTuuu9EIZH..aO7UQxIhhtfeLHcaIuUPE36Br04lZKWCqVxKsm
 6GZyo4hyz6UCRUpdnZ9jdLarOvsHhgtRTQg11RjKyJs1wL9Dmrb4ztzQeM64
 xPRY-
X-Mailer: YahooMailWebService/0.8.114.317681
Message-ID: <1318876329.69798.YahooMailNeo@web110406.mail.gq1.yahoo.com>
Date: Mon, 17 Oct 2011 11:32:09 -0700 (PDT)
From: SUJA JAMES <sujamoljames@yahoo.com>
Reply-To: SUJA JAMES <sujamoljames@yahoo.com>
Subject: Performance Events/Hw Cache Miss counting 
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Message body
Hi All,

I am trying to query the performance management counters on my box,
which is based on Kernel 2.6.38 and running Intel processor.  I am
trying to do the same from my kernel module itself as I need to
profile my kernel modules. I use the
perf_event_create_kernel_counter() api with the following attr/config

The below  attrs/configuration is working and I am getting the counter
values/overflow_handler is getting called.
static struct perf_event_attr counter_attrs[] = {
{
      {
    .type        = PERF_TYPE_HARDWARE,
    .config        = PERF_COUNT_HW_CACHE_MISSES,
    .size        = sizeof(struct perf_event_attr),
    .pinned    = 1,
    .disabled    = 0,
    },
};

But, when I use the following attrs/config, the
perf_event_create_kernel_counter() API is failing.  Ie,
(IS_ERR(returned_pevent) is TRUE and the event is not triggered on the
CPU.  I even tried “PERF_TYPE_HARDWARE” type also with the below
config. Also I used different values for "sample_period" [100 to 1000]

static struct perf_event_attr counter_attrs[] = {
{
    .type          =  PERF_TYPE_HW_CACHE,
.config      =    PERF_COUNT_HW_CACHE_L1D               <<  0  |
              (PERF_COUNT_HW_CACHE_OP_READ           <<  8) |
            (PERF_COUNT_HW_CACHE_RESULT_MISS       << 16),
    .size      = sizeof(struct perf_event_attr),
    .pinned  = 1,
    .disabled = 0,
    },
};

Does anybody know why?. What “config” value  I should use to query the
L1D/ L1I cache misses. I think the “PERF_COUNT_HW_CACHE_MISSES” counts
only 2nd and 3rd level caches.

Thanks,
Suja

