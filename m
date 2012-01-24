Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab2AXTiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 14:38:03 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:35800 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab2AXTiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 14:38:01 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] perf: Add sysfs format attribute for pmu device
References: <20120109152855.GA1597@m.brq.redhat.com>
	<1326717103-10287-1-git-send-email-jolsa@redhat.com>
	<1326717103-10287-6-git-send-email-jolsa@redhat.com>
	<m1bopupi3v.fsf@fess.ebiederm.org>
	<20120123153350.GB1821@m.redhat.com> <1327418538.2446.61.camel@twins>
Date: Tue, 24 Jan 2012 11:40:28 -0800
In-Reply-To: <1327418538.2446.61.camel@twins> (Peter Zijlstra's message of
	"Tue, 24 Jan 2012 16:22:18 +0100")
Message-ID: <m139b4khxv.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18GILZjKg6DiKNVEke1OfuxxI80J4bWEm4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> writes:

> On Mon, 2012-01-23 at 16:33 +0100, Jiri Olsa wrote:
>>   
>> > > +static ssize_t perf_default_event_format(struct pmu *pmu, char *page)
>> > > +{
>> > > +	ssize_t ret;
>> > > +
>> > > +	ret  = sprintf(page,       "config  config:0-63\n");
>> > > +	ret += sprintf(page + ret, "config1 config1:0-63\n");
>> > > +	ret += sprintf(page + ret, "config2 config2:0-63\n");
>> > 
>> > This looks like abuse of sysfs.  The rule is one value per file.
>> > When you start adding newlines I can't see how this format attribute can
>> > be considered one value.
>> 
>> ops, missed that rule.. I think we can carry the syntax files
>> within perf, or have it builtin somehow.. or procfs? :) PeterZ?
>
> There's plenty of exceptions to this rule though and touching procfs is
> even less appreciated.

There may be exceptions but certainly not plenty of exceptions.

There is also a practical scaling problem.  You have to be careful
with how big you make that value before you have problems.

Perhaps what you want is a directory with a bunch of sysfs attributes?

All I know is I see buffer overflows waiting to happen whenever I look
at the code snippet above.

Eric
