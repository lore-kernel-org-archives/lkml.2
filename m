Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab2IOCTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 22:19:31 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43438 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab2IOCTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 22:19:30 -0400
MIME-Version: 1.0
In-Reply-To: <CA+cF-pt5_SENuizLXjQOSC4gJ8hMOnc9SamALLU77RWvwFa-sQ@mail.gmail.com>
References: <CA+cF-pv-a37D=a-ugNSWp8=z+y6H04B+eJHhnmBADsTBe1Edrw@mail.gmail.com>
	<20120915015703.GR13973@ZenIV.linux.org.uk>
	<CA+cF-pv2gyn+LqUAwyiojmzC=6y+mjqf1KkaV_86jMZaJ0oJtQ@mail.gmail.com>
	<20120915021104.GS13973@ZenIV.linux.org.uk>
	<CA+cF-pt5_SENuizLXjQOSC4gJ8hMOnc9SamALLU77RWvwFa-sQ@mail.gmail.com>
Date: Fri, 14 Sep 2012 19:19:29 -0700
Message-ID: <CA+cF-psuziZTJ=+OaRDszXWh6tjdo7QJW01kd-kUFcguUerGWg@mail.gmail.com>
Subject: Re: Getting debugfs mountpoint?
From: Jacob Sowles <sowlesj@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

debugfs_create_dir, rather. Not debugfs_create_file.

On Fri, Sep 14, 2012 at 7:17 PM, Jacob Sowles <sowlesj@gmail.com> wrote:
> The first instance of my code calls debugfs_create_file and stores a
> pointer to the dentry of that directory. But when the second instance
> calls debugfs_create_file, the function returns NULL because that
> directory already exists, so it doesn't return the dentry that I need.
>
> On Fri, Sep 14, 2012 at 7:11 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> On Fri, Sep 14, 2012 at 07:07:43PM -0700, Jacob Sowles wrote:
>>> Multiple instances of my code can be run simultaneously, and all
>>> instances use the same debugfs directory, so I need the path to the
>>> debugfs root directory so that I can use filp_open to get the dentry
>>> for that directory.
>>
>> What's wrong with just storing a pointer to that dentry in a variable?
>> And what do you want an opened file (of a directory, at that) on debugfs?
