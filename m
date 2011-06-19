Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab1FSR7t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 13:59:49 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58113 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab1FSR7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 13:59:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=KSdoQJk0ZtI92y38EiGGOooqdyS1G7XQq8jwpN0WfkAGK09c3sViAqmqcqtS0tkHs7
         VjNP0rPIggsdRqqMSEg+cmXNpPDkeVml21eCl4jLYx8a2YERkJ1DnQscUTJw6vnDg6Y7
         wDdyeFrEse5istE9XtRtSHA+jOh6Fy7MQrz1Q=
Date: Sun, 19 Jun 2011 20:59:37 +0300
From: Johan Hedberg <johan.hedberg@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Waldemar.Rymarkiewicz@tieto.com, padovan@profusion.mobi,
        marcel@holtmann.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Regression caused by "Bluetooth: Map sec_level to link key
 requirements"
Message-ID: <20110619175937.GA24188@dell.ger.corp.intel.com>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Waldemar.Rymarkiewicz@tieto.com, padovan@profusion.mobi,
	marcel@holtmann.org, linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <yunboy7a2so.fsf@aiko.keithp.com>
 <99B09243E1A5DA4898CDD8B700111448175AA2DB2A@EXMB04.eu.tieto.com>
 <20110609083345.GA2894@dell.ccr.corp.intel.com>
 <yuny61b3pnm.fsf@aiko.keithp.com>
 <99B09243E1A5DA4898CDD8B700111448175AA2DE98@EXMB04.eu.tieto.com>
 <20110610055558.GA1832@dell>
 <BANLkTim4F8ZvWPMHSXpcBj9Eb2uFThcz4w@mail.gmail.com>
 <yun8vsynkiy.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yun8vsynkiy.fsf@aiko.keithp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keith,

On Sun, Jun 19, 2011, Keith Packard wrote:
> On Fri, 10 Jun 2011 14:58:50 +0900, Luiz Augusto von Dentz <luiz.dentz@gmail.com> wrote:
> 
> > diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
> > index 2f5ae53..b309f84 100644
> > --- a/net/bluetooth/hci_conn.c
> > +++ b/net/bluetooth/hci_conn.c
> > @@ -673,8 +673,8 @@ auth:
> >         if (test_and_set_bit(HCI_CONN_ENCRYPT_PEND, &conn->pend))
> >                 return 0;
> > 
> > -       hci_conn_auth(conn, sec_level, auth_type);
> > -       return 0;
> > +       if (!(hci_conn_auth(conn, sec_level, auth_type)))
> > +               return 0;
> > 
> >  encrypt:
> >         if (conn->link_mode & HCI_LM_ENCRYPT)
> 
> That makes the first connection afer boot succeed, but subsequent
> connections fail in the same way.

Did you try also the following patch (which should also be making it to
3.0):
http://git.kernel.org/?p=linux/kernel/git/padovan/bluetooth-2.6.git;a=commitdiff;h=330605423ca6eafafb8dcc27502bce1c585d1b06

I think you'll need both of them to fix the pairing/security issues.

Johan
