Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965079Ab2EWDgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 23:36:35 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:32795 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757431Ab2EWDge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 23:36:34 -0400
Message-ID: <1337744190.13111.33.camel@joe2Laptop>
Subject: Re: [Bcache v13 09/16] Bcache: generic utility code
From: Joe Perches <joe@perches.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: Tejun Heo <tejun@google.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com
Date: Tue, 22 May 2012 20:36:30 -0700
In-Reply-To: <20120523031214.GA607@dhcp-172-18-216-138.mtv.corp.google.com>
References: <cover.1336619038.git.koverstreet@google.com>
	 <c3f0ca2a499f532253d4c16a30837d43e237266a.1336619038.git.koverstreet@google.com>
	 <20120522211706.GH14339@google.com>
	 <20120523031214.GA607@dhcp-172-18-216-138.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-22 at 23:12 -0400, Kent Overstreet wrote:
> On Tue, May 22, 2012 at 02:17:06PM -0700, Tejun Heo wrote:
[]
> > > +ssize_t hprint(char *buf, int64_t v)
> > > +{
> > > +	static const char units[] = "?kMGTPEZY";
> > > +	char dec[3] = "";
> > > +	int u, t = 0;
> > > +
> > > +	for (u = 0; v >= 1024 || v <= -1024; u++) {
> > > +		t = v & ~(~0 << 10);
> > > +		v >>= 10;
> > > +	}
> > > +
> > > +	if (!u)
> > > +		return sprintf(buf, "%llu", v);
> > > +
> > > +	if (v < 100 && v > -100)
> > > +		sprintf(dec, ".%i", t / 100);
> > > +
> > > +	return sprintf(buf, "%lli%s%c", v, dec, units[u]);
> > > +}
> > > +EXPORT_SYMBOL_GPL(hprint);
> > 
> > Not your fault but maybe we want integer vsnprintf modifier for this.
> 
> Yes.

or maybe yet another lib/vsprintf pointer extension
like %pD with some descriptors after the %pD for
type, width and precision.


