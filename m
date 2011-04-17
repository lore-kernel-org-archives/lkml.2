Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab1DQW4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 18:56:18 -0400
Received: from solo.fdn.fr ([80.67.169.19]:35878 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923Ab1DQW4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 18:56:14 -0400
X-Greylist: delayed 524 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Apr 2011 18:56:14 EDT
Date: Mon, 18 Apr 2011 00:46:40 +0200
From: Samuel Thibault <samuel.thibault@labri.fr>
To: linux-kernel@vger.kernel.org
Subject: Hardware locality (hwloc) v1.2 released
Message-ID: <20110417224640.GA5497@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@labri.fr>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Hardware Locality (hwloc) team is pleased to announce the release of v1.2:

    http://www.open-mpi.org/projects/hwloc/ 

v1.2 is a major new release series for hwloc.  It includes many new features
and changes over the v1.1.x series.
The recently-released v1.1.2 is expected to be the last release of its series
(see http://www.open-mpi.org/community/lists/hwloc-announce/2011/04/0014.php).

The following is a summary of the changes since the v1.1 series:

* Major features
  + Expose latency matrices in the API as an array of distance structures
    within objects. Add several helpers to find distances.
  + Add hwloc_topology_set_distance_matrix() and environment variables
    to provide a matrix of distances between a given set of objects.
  + Add hwloc_get_last_cpu_location() and hwloc_get_proc_last_cpu_location()
    to retrieve the processors where a process or thread recently ran.
    - Add the corresponding --get-last-cpu-location option to hwloc-bind.
  + Add hwloc_topology_restrict() to restrict an existing topology to a
    given cpuset.
    - Add the corresponding --restrict option to lstopo.
* Minor API updates
  + Add hwloc_bitmap_list_sscanf/snprintf/asprintf to convert between bitmaps
    and strings such as 4-5,7-9,12,15-
  + hwloc_bitmap_set/clr_range() now support infinite ranges.
  + Clarify the difference between inserting Misc objects by cpuset or by
    parent.
  + hwloc_insert_misc_object_by_cpuset() now returns NULL in case of error.
* Discovery improvements
  + x86 backend (for freebsd): add x2APIC support
  + Support standard device-tree phandle, to get better support on e.g. ARM
    systems providing it.
  + Detect cache size on AIX. Thanks Christopher and IBM.
  + Improve grouping to support asymmetric topologies.
* Tools
  + Command-line tools now support "all" and "root" special locations
    consisting in the entire topology, as well as type names with depth
    attributes such as L2 or Group4.
  + hwloc-calc improvements:
    - Add --number-of/-N option to report the number of objects of a given
      type or depth.
    - -I is now equivalent to --intersect for listing the indexes of
      objects of a given type or depth that intersects the input.
    - Add -H to report the output as a hierarchical combination of types
      and depths.
  + Add --thissystem to lstopo.
  + Add lstopo-win, a console-less lstopo variant on Windows.
* Miscellaneous
  + Remove C99 usage from code base.
  + Rename hwloc-gather-topology.sh into hwloc-gather-topology
  + Fix AMD cache discovery on freebsd when there is no L3 cache, thanks
    Andriy Gapon for the fix.

The next release series (v1.3.x) will focus on adding I/O devices to the
topology.
