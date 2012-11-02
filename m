Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab2KBKlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 06:41:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520Ab2KBKlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 06:41:09 -0400
Date: Fri, 2 Nov 2012 11:40:52 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHv2 03/25] perf tests: Add framework for automated
 perf_event_attr tests
Message-ID: <20121102104052.GC1157@krava.brq.redhat.com>
References: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
 <1351634526-1516-4-git-send-email-jolsa@redhat.com>
 <20121030230120.GA1067@krava.redhat.com>
 <20121031142600.GB28061@ghostprotocols.net>
 <20121031145247.GB1027@krava.brq.redhat.com>
 <87fw4s4ui7.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fw4s4ui7.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 11:18:56AM +0900, Namhyung Kim wrote:
> On Wed, 31 Oct 2012 15:52:47 +0100, Jiri Olsa wrote:
> > Adding automated test to check event's perf_event_attr values.
> > +#define WRITE_ASS(str, fmt, data)					\
> > +do {									\
> > +	char buf[BUFSIZE];						\
> > +	size_t size;							\
> > +									\
> > +	size = snprintf(buf, BUFSIZE, #str "=%"fmt "\n", data);		\
> > +	if (1 != fwrite(buf, size, 1, file)) {				\
> > +		perror("test attr - failed to write event file");	\
> > +		fclose(file);						\
> > +		return -1;						\
> > +	}								\
> > +									\
> > +} while (0)
> 
> What is ASS?

short for assignment

> 
> > +
> > +static int store_event(struct perf_event_attr *attr, pid_t pid, int cpu,
> > +		       int fd, int group_fd, unsigned long flags)
> > +{
> > +	FILE *file;
> > +	char path[PATH_MAX];
> > +

SNIP

> > +	WRITE_ASS(sample_regs_user,   "llu", attr->sample_regs_user);
> > +	WRITE_ASS(sample_stack_user,  PRIu32, attr->sample_stack_user);
> > +	WRITE_ASS(optional, "d", 0);
> 
> How about rename current WRITE_ASS to __WRITE_ASS and create a wrapper
> WRITE_ASS like this:
> 
>   #define WRITE_ASS(field, fmt)  __WRITE_ASS(field, fmt, attr->field)
> 
> and use __WRITE_ASS for 'optional'.

looks ok

> 
> > +
> > +	fclose(file);
> > +	return 0;
> > +}
> [snip]
> > +    def compare_data(self, a, b):
> > +        a_list = a.split('|')
> > +        b_list = b.split('|')
> > +
> > +        for a_item in a_list:
> > +            for b_item in b_list:
> > +                if (a_item == b_item):
> > +                    return True
> > +                elif (a_item == '*') or (b_item == '*'):
> > +                    return True
> > +
> > +        return False
> 
> I think it needs some comments about how it works.
> 
> > +
> [snip]
> > +    def load_events(self, path, events):
> > +        parser_event = ConfigParser.SafeConfigParser()
> > +        parser_event.read(path)
> > +
> > +        for section in filter(self.is_event, parser_event.sections()):
> > +
> > +            parser_items = parser_event.items(section);
> > +            base_items   = {}
> > +
> > +            if (':' in section):
> > +                base = section[section.index(':') + 1:]
> > +                parser_base = ConfigParser.SafeConfigParser()
> > +                parser_base.read(self.test_dir + '/' + base)
> > +                base_items = parser_base.items('event')
> > +
> > +            e = Event(section, parser_items, base_items)
> > +            events[section] = e
> 
> And this too. :)

ok, will try ;)

thanks,
jirka
