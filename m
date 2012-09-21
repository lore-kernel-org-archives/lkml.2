Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab2IUCZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 22:25:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756694Ab2IUCZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 22:25:46 -0400
Message-ID: <505BD027.1070509@redhat.com>
Date: Thu, 20 Sep 2012 21:25:43 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: kernel list <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH V2] perf: Fix parallel build
References: <505BAC5D.9020909@redhat.com> <505BBF12.4060800@redhat.com> <87392cyvpl.fsf@sejong.aot.lge.com>
In-Reply-To: <87392cyvpl.fsf@sejong.aot.lge.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/20/12 9:07 PM, Namhyung Kim wrote:
> Hi again,
> 
> On Thu, 20 Sep 2012 20:12:50 -0500, Eric Sandeen wrote:
>> -$(OUTPUT)util/parse-events-flex.c: util/parse-events.l
>> +$(OUTPUT)util/parse-events-flex.c: util/parse-events.l util/parse-events-bison.c
> 
> I realized that the generated *-bison.c files should have $(OUTPUT)
> prefix since they can be under another directory than *.[ly] files.
> 
> 
>>  	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/parse-events-flex.h $(PARSER_DEBUG_FLEX) -t util/parse-events.l > $(OUTPUT)util/parse-events-flex.c
>>  
>>  $(OUTPUT)util/parse-events-bison.c: util/parse-events.y
>>  	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d $(PARSER_DEBUG_BISON) -o $(OUTPUT)util/parse-events-bison.c
>>  
>> -$(OUTPUT)util/pmu-flex.c: util/pmu.l
>> +$(OUTPUT)util/pmu-flex.c: util/pmu.l util/pmu-bison.c
> 
> Ditto.

Sorry.  Too long since I worked on Makefiles :(

V3 soon ;)

-Eric

> Thanks,
> Namhyung
> 
> 
>>  	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/pmu-flex.h -t util/pmu.l > $(OUTPUT)util/pmu-flex.c
>>  
>>  $(OUTPUT)util/pmu-bison.c: util/pmu.y

