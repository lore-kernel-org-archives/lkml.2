Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab1AZAcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 19:32:45 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:26923 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752465Ab1AZAcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 19:32:43 -0500
Subject: Re: [PATCH] video/saa7164: Fix sparse warning: Using plain integer
 as NULL pointer
From: Andy Walls <awalls@md.metrocast.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Peter =?ISO-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>,
        Julia Lawall <julia@diku.dk>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Steven Toth <stoth@kernellabs.com>,
        Tejun Heo <tj@kernel.org>, Dan Carpenter <error27@gmail.com>
In-Reply-To: <AANLkTinap-4djdUORmOnnnVFtTm4wSxMqTNVxrfg2jYw@mail.gmail.com>
References: <1295988851-23561-1-git-send-email-peterhuewe@gmx.de>
	 <Pine.LNX.4.64.1101252319570.3668@ask.diku.dk>
	 <201101252354.31217.PeterHuewe@gmx.de>
	 <AANLkTinap-4djdUORmOnnnVFtTm4wSxMqTNVxrfg2jYw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 19:30:13 -0500
Message-ID: <1296001813.25686.27.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-01-25_09:2011-01-26,2011-01-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1012030000 definitions=main-1101250190
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-25 at 18:05 -0500, Devin Heitmueller wrote:
> On Tue, Jan 25, 2011 at 5:54 PM, Peter Hüwe <PeterHuewe@gmx.de> wrote:
> > Hi Julia,
> >
> > thanks for your input.
> > So do I understand you correctly if I say
> > if(!x) is better than if(x==NULL) in any case?

The machine code should be equivalent in size and speed.


> > Or only for the kmalloc family?
> >
> > Do you remember the reason why !x should be preferred?
> >
> > In Documentation/CodingStyle ,  Chapter 7: Centralized exiting of functions
> > there is a function fun with looks like this:
> > int fun(int a)
> > {
> >    int result = 0;
> >    char *buffer = kmalloc(SIZE);
> >
> >    if (buffer == NULL)
> >        return -ENOMEM;

> >
> > -->  So   if (buffer == NULL) is in the official CodingStyle - maybe we should
> > add a paragraph there as well ;)


CodingStyle shouldn't specify anything on the matter.  There is no
overall, optimal choice for all contexts.   Arguing either way is as
pointless as the Lilliputians' little-end vs. big-end dispute.


> To my knowledge, the current CodingStyle doesn't enforce a particular
> standard in this regard, leaving it at the discretion of the author.

Correct, it does not.  I just checked CodingStyle and checkpatch
yesterday.


> Whether to do (!foo) or (foo == NULL) is one of those debates people
> have similar to whether to use tabs as whitespace.  People have
> differing opinions and there is no clearly "right" answer.

It depends on one's measurement criteria for "optimizing" the written
form of source code.

I prefer more explicit statement of action is taking place over
statements with fewer characters.  It usually saves me time when
revisiting code.

More genrally I prefer any coding practice that saves me time when
revisiting code.  (Note the word "me" carries a lot of context with it.)

Ambiguity and implicit behaviors ultimately waste my time.


>   Personally
> I strongly prefer (foo == NULL) as it makes it blindingly obvious that
> it's a pointer comparison, whereas (!foo) leaves you wondering whether
> it's an integer or pointer comparison.

<usenet>
Me too.
</usenet>


> All that said, you shouldn't submit patches which arbitrarily change
> from one format to the other.  With regards to the proposed patch, you
> should follow whatever style the author employed in the rest of the
> file.

That is another reasonable critereon in "optimizing" the written form of
the source code.  I tend to give it less weight though.


Regards,
Andy

