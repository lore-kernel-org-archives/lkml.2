Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab2EZN42 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 09:56:28 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33033 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab2EZN41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 09:56:27 -0400
Date: Sat, 26 May 2012 14:59:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: =?ISO-8859-1?B?yXJpYw==?= Piel <eric.piel@tremplin-utc.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        "lkml, " <linux-kernel@vger.kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Carmine Iascone <carmine.iascone@st.com>,
        Matteo Dameno <matteo.dameno@st.com>
Subject: Re: LIS331DLH accelerometer driver, IIO or not?
Message-ID: <20120526145914.47b7812d@pyramind.ukuu.org.uk>
In-Reply-To: <4FC0C422.8080605@tremplin-utc.net>
References: <4FBF0AC1.6030406@linux.intel.com>
	<20120525051051.GA3135@kroah.com>
	<4FC0C422.8080605@tremplin-utc.net>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Make it an IIO driver and then we can delete the misc driver, which
> > shouldn't have snuck in there in the first place :)
> >
> 
> To be more fair to the misc driver, I wouldn't say it snucked in there, 
> but more "it ended up there as the least worse place" ;-)

Because IIO spent forever in staging, as well as blocking lots of other
driver work and meaning tons of drivers are now not to be found anywhere
but obscure git trees. Thankfully they didn't manage to block the LIS
driver during this mess.

Until all the needed support for the LIS IIO driver exists outside of
staging the driver needs to stay where it is and without IIO
dependancies. It is not acceptable to cripple existing working code with
staging tree dependancies.

Hopefully commit a980e046098b0a40eaff5e4e7fcde6cf035b7c06 has finally set
the basis for this happening when it hits mainline.

Alan
