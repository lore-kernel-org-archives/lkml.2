Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab1CVQlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 12:41:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63058 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab1CVQlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 12:41:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 6/7] char/mei: Header file contain the Userland API, (IOCTL and its struct)
Date: Tue, 22 Mar 2011 17:41:17 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Oren Weil <oren.jer.weil@intel.com>, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, david@woodhou.se
References: <1300791092-14319-1-git-send-email-oren.jer.weil@intel.com> <1300791092-14319-7-git-send-email-oren.jer.weil@intel.com> <20110322162603.GB14737@suse.de>
In-Reply-To: <20110322162603.GB14737@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103221741.18141.arnd@arndb.de>
X-Provags-ID: V02:K0:DWfYfroXUWOVQhQglbS5NL/rtHRF4SMEF7EEGjVIWWR
 Ir0IW3gJ3qZPYfzSre7KtWAz2WbaIhJtJuONnW2jvnZvvkFzrn
 yzPNTGjNHUfBu3TCNH7qt9hoKI6QZQxUDsygsVmkd8WpEnINnk
 t/6gA9Mw4s2VxV8a9CGl+hJUMKdy+2KKqhiOkh+Nhj6jyYEV6z
 /l0TEPlDiu6WCm/Esk0cA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 March 2011, Greg KH wrote:
> On Tue, Mar 22, 2011 at 12:51:31PM +0200, Oren Weil wrote:
> > +/*
> > + * Intel MEI client information struct
> > + */
> > +struct mei_client {
> > +     u32 max_msg_length;
> > +     u8 protocol_version;
> > +     u8 reserved[3];
> > +} __packed;
> 
> As this is passing the kernel/user boundry, you need to use the proper
> data types for it.
> 
> So use __u32 and __u8 here please.

Also, __packed should not be used in APIs, because it is a gcc extension
and makes the code less efficient.

> > +/*
> > + * IOCTL Connect Client Data structure
> > + */
> > +struct mei_connect_client_data {
> > +     union {
> > +             uuid_le in_client_uuid;
> > +             struct mei_client out_client_propeties;
> > +     } d;
> 
> Why not an anonymous union?

That would also incompatible with some compilers. I would recommend
not using a union at all, but simply to put all in one struct.

	Arnd
