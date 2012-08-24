Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab2HXJQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 05:16:31 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:65051 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab2HXJQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 05:16:27 -0400
X-AuditID: 9c93016f-b7cc0ae000000e9f-ec-50374669d3e8
From: Namhyung Kim <namhyung@kernel.org>
To: Bernhard Rosenkraenzer <bernhard.rosenkranzer@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/1] perf: Port to Android
References: <1408973.PFKjjaXiS1@localhost.localdomain>
	<87boi0hdcv.fsf@sejong.aot.lge.com>
Date: Fri, 24 Aug 2012 18:09:49 +0900
In-Reply-To: <87boi0hdcv.fsf@sejong.aot.lge.com> (Namhyung Kim's message of
	"Fri, 24 Aug 2012 18:02:24 +0900")
Message-ID: <877gsohd0i.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2012 18:02:24 +0900, Namhyung Kim wrote:
> On Thu, 23 Aug 2012 17:01:52 +0200, Bernhard Rosenkraenzer wrote:
[SNIP]
>> +
>> +/* Assorted functions that are missing from Bionic */
>> +static void psignal(int sig, const char *s)
>> +{
>> +	if(sig >= 0 && sig < NSIG) {
>> +		if(s)
>> +			fprintf(stderr, "%s: %s\n", s, sys_siglist[sig]);
>> +		else
>> +			fprintf(stderr, "%s\n", sys_siglist[sig]);
>> +	} else {
>> +		if(s)
>> +			fprintf(stderr, "%s: invalid signal\n", s);
>> +		else
>> +			fputs("invalid signal\n", stderr);
>> +	}
>> +}
>> +
>> +static ssize_t getline(char **lineptr, size_t *n, FILE *stream)
>> +{
>> +	size_t ret = 0;
>> +
>> +	if (!lineptr || !n || !stream)
>> +		return -1;
>> +
>> +	if(!*lineptr) {
>> +		*n = 128;
>> +		*lineptr = (char*)malloc(*n);
>> +		if(!*lineptr)
>> +			return -1;
>> +	}
>> +
>> +	while(!feof(stream) && !ferror(stream)) {
>> +		int c;
>> +		if(ret == *n) {
>> +			*n += 128;
>> +			*lineptr = (char*)realloc(*lineptr, *n);
>> +			if(!*lineptr) {
>> +				*n = 0;
>> +				return -1;
>> +			}
>> +		}
>> +		c = fgetc(stream);
>> +		if(c == EOF)
>> +			break;
>> +		*lineptr[ret++] = c;
>> +		if(c == '\n')
>> +			break;
>> +	}
>> +	*lineptr[ret] = 0;
>> +	return ret;
>> +}
>
> And above two functions can be moved too somehow.

I meant it can be moved to the .c file.

Thanks,
Namhyung
